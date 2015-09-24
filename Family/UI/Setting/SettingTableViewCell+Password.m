//
//  SettingTableViewCell+Password.m
//  Family
//
//  Created by jia on 15/9/23.
//  Copyright © 2015年 jia. All rights reserved.
//

#import "SettingTableViewCell+Password.h"

@implementation SettingTableViewCell (Password)

static char passwordTypeKey;
- (void)setPasswordType:(SettingCellPasswordType)passwordType
{
    objc_setAssociatedObject(self, &passwordTypeKey, @(passwordType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SettingCellPasswordType)passwordType
{
    return [(NSNumber *)objc_getAssociatedObject(self, &passwordTypeKey) integerValue];
}

@end
