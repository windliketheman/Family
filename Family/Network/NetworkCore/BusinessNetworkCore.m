//
//  BusinessNetworkCore.m
//  Family
//
//  Created by jia on 15/9/11.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "BusinessNetworkCore.h"
#import "BusinessNetworkCore+Business.h"

#define DoNetworkCoreCache 0
#if DoNetworkCoreCache
#import "Reachability.h"
#endif

#define WORKAROUND_MUTABLE_COPY 0

#if WORKAROUND_MUTABLE_COPY
// required to workaround http://openradar.appspot.com/11596316
@interface NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround;

@end

@implementation NSURLRequest(MutableCopyWorkaround)

- (id)mutableCopyWorkaround
{
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[self URL]
                                                                          cachePolicy:[self cachePolicy]
                                                                      timeoutInterval:[self timeoutInterval]];
    [mutableURLRequest setAllHTTPHeaderFields:[self allHTTPHeaderFields]];
    if ([self HTTPBodyStream])
    {
        [mutableURLRequest setHTTPBodyStream:[self HTTPBodyStream]];
    }
    else
    {
        [mutableURLRequest setHTTPBody:[self HTTPBody]];
    }
    [mutableURLRequest setHTTPMethod:[self HTTPMethod]];
    
    return mutableURLRequest;
}

@end
#endif


@interface NetworkCoreCachedData : NSObject <NSCoding>
@property (nonatomic, readwrite, strong) NSData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
@property (nonatomic, readwrite, strong) NSURLRequest *redirectRequest;
@end

static NSString *const kDataKey = @"data";
static NSString *const kResponseKey = @"response";
static NSString *const kRedirectRequestKey = @"redirectRequest";

@implementation NetworkCoreCachedData
@synthesize data = data_;
@synthesize response = response_;
@synthesize redirectRequest = redirectRequest_;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self data] forKey:kDataKey];
    [aCoder encodeObject:[self response] forKey:kResponseKey];
    [aCoder encodeObject:[self redirectRequest] forKey:kRedirectRequestKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil)
    {
        [self setData:[aDecoder decodeObjectForKey:kDataKey]];
        [self setResponse:[aDecoder decodeObjectForKey:kResponseKey]];
        [self setRedirectRequest:[aDecoder decodeObjectForKey:kRedirectRequestKey]];
    }
    
    return self;
}

@end


@interface BusinessNetworkCore ()
@end

static NSString *__networkCoreURLHeader = @"X-NetworkCoreCache";

@implementation BusinessNetworkCore

#pragma mark - Rewrite Super

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:[self requestMarker] inRequest:request])
    {
        return NO;
    }
    
    NSString *urlScheme = [[request URL] scheme];
    NSDictionary *headerFields = [request allHTTPHeaderFields];
#if DEBUG
    NSLog(@"HTTPHeaderFields: %@", [headerFields description]);
#endif
    
#if 1
    // only handle http requests we haven't marked with our header.
    BOOL supported = [[self supportedSchemes] containsObject:urlScheme];
    NSString *httpHeaderField = [request valueForHTTPHeaderField:__networkCoreURLHeader];
    if (supported && !httpHeaderField)
    {
        return YES;
    }
    return NO;
#else
    BOOL canDo =
    [headerFields objectForKey:@"custom_header"] == nil &&
    ([urlScheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
     [urlScheme caseInsensitiveCompare:@"https"] == NSOrderedSame);
    return canDo;
#endif
}

+ (NSString *)requestMarker
{
    return NSStringFromClass([self class]);
}

+ (void)applyCustomHeaders:(NSMutableURLRequest *)mutableReqeust
{
    [super applyCustomHeaders:mutableReqeust];
    
    [mutableReqeust setValue:@"" forHTTPHeaderField:__networkCoreURLHeader];
    
    [self applyBuninessHeaders:mutableReqeust];
}

// 无网情况下 使用cache
- (BOOL)useCache
{
#if DoNetworkCoreCache
    BOOL reachable = (BOOL)[[Reachability reachabilityWithHostname:[[[self request] URL] host]] currentReachabilityStatus] != NotReachable;
    return !reachable;
#else
    return NO;
#endif
}

- (void)startLoadingCache
{
#if DoNetworkCoreCache
    // 使用缓存
    NetworkCoreCachedData *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathForRequest:[self request]]];
    if (cache)
    {
        NSData *data = [cache data];
        NSURLResponse *response = [cache response];
        NSURLRequest *redirectRequest = [cache redirectRequest];
        if (redirectRequest)
        {
            [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
        }
        else
        {
            [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed]; // we handle caching ourselves.
            [[self client] URLProtocol:self didLoadData:data];
            [[self client] URLProtocolDidFinishLoading:self];
        }
    }
    else
    {
        [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil]];
    }
#endif
}

#pragma mark - NSURLConnection
#if DoNetworkCoreCache
// NSURLConnection delegates (generally we pass these on to our client)
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    // Thanks to Nick Dowell https://gist.github.com/1885821
    if (response != nil)
    {
        NSMutableURLRequest *redirectableRequest =
#if WORKAROUND_MUTABLE_COPY
        [request mutableCopyWorkaround];
#else
        [request mutableCopy];
#endif
        // We need to remove our header so we know to handle this request and cache it.
        // There are 3 requests in flight: the outside request, which we handled, the internal request,
        // which we marked with our header, and the redirectableRequest, which we're modifying here.
        // The redirectable request will cause a new outside request from the NSURLProtocolClient, which
        // must not be marked with our header.
        [redirectableRequest setValue:nil forHTTPHeaderField:__networkCoreURLHeader];
        
        NSString *cachePath = [self cachePathForRequest:[self request]];
        NetworkCoreCachedData *cache = [NetworkCoreCachedData new];
        [cache setResponse:response];
        [cache setData:[self data]];
        [cache setRedirectRequest:redirectableRequest];
        [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
        
        // 如果没有通过[self client]回传消息，那么需要重定向的网页就会出现问题:host不对或者造成跨域调用导致资源无法加载。
        [[self client] URLProtocol:self wasRedirectedToRequest:redirectableRequest redirectResponse:response];
        return redirectableRequest;
    }
    else
    {
        NSLog(@"request: %@", [request.URL absoluteString]);
        return request;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    [self setConnection:nil];
    [self setData:nil];
    [self setResponse:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self setResponse:response];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];  // We cache ourselves.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self client] URLProtocolDidFinishLoading:self];
    
    NSString *cachePath = [self cachePathForRequest:[self request]];
    NetworkCoreCachedData *cache = [NetworkCoreCachedData new];
    [cache setResponse:[self response]];
    [cache setData:[self data]];
    [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
    
    [self setConnection:nil];
    [self setData:nil];
    [self setResponse:nil];
}

- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest
{
    // This stores in the Caches directory, which can be deleted when space is low, but we only use it for offline access
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [[[aRequest URL] absoluteString] sha1];
    
    return [cachesPath stringByAppendingPathComponent:fileName];
}

- (void)appendData:(NSData *)newData
{
    if ([self data] == nil)
    {
        [self setData:[newData mutableCopy]];
    }
    else
    {
        [[self data] appendData:newData];
    }
}
#endif

@end
