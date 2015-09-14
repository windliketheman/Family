//
//  NetworkCore.m
//  Family
//
//  Created by jia on 15/8/27.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "NetworkCore.h"

@interface NetworkCore () // <NSURLConnectionDelegate, NSURLConnectionDataDelegate> iOS5-only

@end

@implementation NetworkCore

static NSObject *__supportedSchemesMonitor;
static NSSet *__supportedSchemes;

+ (void)initialize
{
    if (self == [NetworkCore class])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __supportedSchemesMonitor = [NSObject new];
        });
        
        [self setSupportedSchemes:[NSSet setWithObjects:@"http", @"https", nil]];
    }
}

+ (NSSet *)supportedSchemes
{
    NSSet *supportedSchemes;
    @synchronized (__supportedSchemesMonitor)
    {
        supportedSchemes = __supportedSchemes;
    }
    return supportedSchemes;
}

#pragma mark - Outer Methods
+ (void)doRegister
{
    [NSURLProtocol registerClass:[self class]];
}

+ (void)setSupportedSchemes:(NSSet *)supportedSchemes
{
    @synchronized (__supportedSchemesMonitor)
    {
        __supportedSchemes = supportedSchemes;
    }
}

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
    
    // only handle http requests we haven't marked with our header.
    if ([[self supportedSchemes] containsObject:urlScheme])
    {
        return YES;
    }
    return NO;
}

#pragma mark - Subclass Custom

+ (NSString *)requestMarker
{
    return NSStringFromClass([self class]);
}

+ (void)applyCustomHeaders:(NSMutableURLRequest *)mutableReqeust
{
    //
}

// 无网情况下 使用cache
- (BOOL)useCache
{
    return NO;
}

- (void)startLoadingCache
{
    // NO
}

#pragma mark - 必须实现 begin
// 返回规范化后的request,一般就只是返回当前request即可
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

// 用于判断你的自定义reqeust是否相同，这里返回默认实现即可。它的主要应用场景是某些直接使用缓存而非再次请求网络的地方。
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

// startLoading和stopLoading 实现请求和取消流程
- (void)startLoading
{
    if (![self useCache])
    {
        // 在线请求
        NSMutableURLRequest *mutableReqeust =
#if WORKAROUND_MUTABLE_COPY
        [[self request] mutableCopyWorkaround];
#else
        [[self request] mutableCopy];
#endif
        
        [[self class] applyCustomHeaders:mutableReqeust];
        [NSURLProtocol setProperty:@(YES)
                            forKey:[[self class] requestMarker]
                         inRequest:mutableReqeust];
        
        self.connection = [NSURLConnection connectionWithRequest:mutableReqeust
                                                        delegate:self];
    }
    else
    {
        [self startLoadingCache];
    }
}

- (void)stopLoading
{
    [[self connection] cancel];
}

#pragma mark 必须实现 end

#pragma mark - NSURLConnection
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self
            didFailWithError:error];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (response != nil)
    {
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self.client URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self
                 didLoadData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

@end

