//
//  BusinessNetworkCore+Business.h
//  Family
//
//  Created by jia on 15/9/11.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "BusinessNetworkCore.h"
#import "ServerConfig.h"
#import "CommonData+Business.h"

extern NSString *const BusinessCommonRequestHeaderField;
extern NSString *const BusinessSecurityRequestHeaderField;

@interface BusinessNetworkCore (Business)

+ (void)applyBuninessHeaders:(NSMutableURLRequest *)mutableReqeust;

@end
