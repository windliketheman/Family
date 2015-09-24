//
//  SecurityStrategy.h
//  FileBox
//
//  Created by JiaJunbo on 15/5/19.
//  Copyright (c) 2015年 OrangeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAuthenticationSuccessNotification @"AuthenticationSuccessNotification"

@interface SecurityStrategy : NSObject

+ (void)run;

+ (BOOL)isProtecting;

+ (void)turnOff;

// 开启高斯模糊
+ (BOOL)isUnderSafeMode;

@end
