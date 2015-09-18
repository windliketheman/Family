//
//  BusinessNetworkCore+Business.m
//  Family
//
//  Created by jia on 15/9/11.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "BusinessNetworkCore+Business.h"

NSString *const BusinessCommonRequestHeaderField = @"x-ennew-req";
NSString *const BusinessSecurityRequestHeaderField = @"x-ennew-sec";

@implementation BusinessNetworkCore (Business)

+ (NSArray *)businessRequestHeaderFieldsForURL:(NSString *)urlString
{
    if ([urlString rangeOfString:GetUserInfoInterface].location != NSNotFound)
    {
        return @[BusinessCommonRequestHeaderField];
    }
    else
    {
        return nil;
    }
}

+ (void)applyBuninessHeaders:(NSMutableURLRequest *)mutableReqeust
{
    NSArray *businessRequestHeaderFields = [self businessRequestHeaderFieldsForURL:[mutableReqeust.URL absoluteString]];
    if (businessRequestHeaderFields)
    {
        NSString *headerFieldKey;
        for (NSString *object in businessRequestHeaderFields)
        {
            if ([object isEqualToString:BusinessCommonRequestHeaderField])
            {
                [mutableReqeust setValue:[self commonRequestHeaderField:&headerFieldKey] forHTTPHeaderField:headerFieldKey];
            }
            else if ([object isEqualToString:BusinessSecurityRequestHeaderField])
            {
                [mutableReqeust setValue:[self securityRequestHeaderField:&headerFieldKey] forHTTPHeaderField:headerFieldKey];
            }
        }
    }
    
    NSDictionary *headerFields = [mutableReqeust allHTTPHeaderFields];
#if DEBUG
    NSLog(@"HTTPHeaderFields: %@", [headerFields description]);
#endif
}

+ (NSString *)commonRequestHeaderField:(NSString **)key
{
    *key = @"x-ennew-req";
    return [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@", [CommonData appid], [CommonData versionCode], [CommonData otaVersion], [CommonData pid], [CommonData uid], [CommonData mid], [CommonData did], [CommonData sid]];
}

+ (NSString *)securityRequestHeaderField:(NSString **)key
{
    *key = @"x-ennew-sec";
    return @"";
}

@end
