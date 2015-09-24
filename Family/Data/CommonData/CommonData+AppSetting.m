//
//  CommonData+AppSetting.m
//  Family
//
//  Created by jia on 15/8/19.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "CommonData+AppSetting.h"

@implementation CommonData (AppSetting)

- (BOOL)isReceiveNewMessage
{
    return self.appSetting.isReceiveNewMessage;
}

- (BOOL)isShowMessageDetail
{
    return self.appSetting.isShowMessageDetail;
}

- (BOOL)isSoundAvaiable
{
    return self.appSetting.isSoundAvaiable;
}

- (BOOL)isVibrateMode
{
    return self.appSetting.isVibrateMode;
}

- (BOOL)isNODisturbAtNight
{
    return self.appSetting.isNODisturbAtNight;
}

- (BOOL)isShowHomelandNews
{
    return self.appSetting.isShowHomelandNews;
}

- (BOOL)isCanSearchMeByPhoneNumberOrName
{
    return self.appSetting.isCanSearchMeByPhoneNumberOrName;
}

- (BOOL)isSendMessageByReturnKey
{
    return self.appSetting.isSendMessageByReturnKey;
}

// psw
+ (BOOL)passwordSwitch
{
    return [self.instance.appSetting passwordSwitch];
}

+ (NSString *)password
{
    return [self.instance.appSetting password];
}

+ (BOOL)touchIDSwitch
{
    return [self.instance.appSetting touchIDSwitch];
}

+ (NSString *)findPasswordQuestion
{
    return [self.instance.appSetting findPasswordQuestion];
}

+ (NSString *)findPasswordAnswer
{
    return [self.instance.appSetting findPasswordAnswer];
}

+ (BOOL)findPasswordQuestionEnable
{
    NSString *question = [CommonData findPasswordQuestion] ? [CommonData findPasswordQuestion] : @"";
    NSString *answer = [CommonData findPasswordAnswer] ? [CommonData findPasswordAnswer] : @"";
    BOOL enable = YES;
    if ([question isEqualToString:@""] && [answer isEqualToString:@""])
    {
        enable = NO;
    }
    return enable;
}

+ (void)setPasswordSwitch:(BOOL)on
{
    [self.instance.appSetting setPasswordSwitch:on];
}

+ (void)setPassword:(NSString *)psw
{
    [self.instance.appSetting setPassword:psw];
}

+ (void)setTouchIDSwitch:(BOOL)on
{
    [self.instance.appSetting setTouchIDSwitch:on];
}

+ (void)setFindPasswordQuestion:(NSString *)q answer:(NSString *)a
{
    [self.instance.appSetting setFindPasswordQuestion:q answer:a];
}
@end
