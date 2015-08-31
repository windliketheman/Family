//
//  RequestCore.h
//  Family
//
//  Created by jia on 15/8/27.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Success)(id result);
typedef void (^Failure)(NSError *error);

@interface RequestCore : NSObject

#pragma mark - Get
+ (void)GET:(NSString *)urlstring params:(NSDictionary *)params success:(Success)successBlock failure:(Failure)failureBlock;

#pragma mark - Post
+ (void)POST:(NSString *)urlstring params:(NSDictionary *)params success:(Success)successBlock failure:(Failure)failureBlock;

+ (void)POST:(NSString *)urlstring params:(NSDictionary *)params returnModel:(Class)dataItemClass success:(Success)successBlock failure:(Failure)failureBlock;

@end
