//
//  NetworkCore.h
//  Family
//
//  Created by jia on 15/8/27.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkCore : NSURLProtocol

+ (void)doRegister;

+ (NSSet *)supportedSchemes;
+ (void)setSupportedSchemes:(NSSet *)supportedSchemes;

- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest;
- (BOOL) useCache;

@end
