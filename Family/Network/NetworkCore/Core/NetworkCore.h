//
//  NetworkCore.h
//  Family
//
//  Created by jia on 15/8/27.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+NetworkCore.h"

@interface NetworkCore : NSURLProtocol
@property (nonatomic, readwrite, strong) NSURLConnection *connection;
@property (nonatomic, readwrite, strong) NSMutableData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;

#pragma mark - Outer Methods
+ (void)doRegister;
+ (void)setSupportedSchemes:(NSSet *)supportedSchemes;
+ (NSSet *)supportedSchemes;

#pragma mark - Subclass to Rewrite these
+ (NSString *)requestMarker;
+ (void)applyCustomHeaders:(NSMutableURLRequest *)mutableReqeust;
- (BOOL)useCache;
- (void)startLoadingCache;

//+ (NSSet *)supportedSchemes;
//+ (void)setSupportedSchemes:(NSSet *)supportedSchemes;
//
//- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest;
//- (BOOL) useCache;

@end
