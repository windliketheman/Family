//
//  AppSetting.m
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "AppSetting.h"
#import "AppSettingKeys.h"

@interface AppSetting ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation AppSetting

- (instancetype)init
{
    if (self = [super init])
    {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (BOOL)havingDataForKey:(NSString *)key
{
    if ([self.userDefaults objectForKey:key])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)setStringObject:(NSString *)string forKey:(NSString *)key
{
    [self.userDefaults setObject:string forKey:key];
    [self.userDefaults synchronize];
}

- (NSString *)stringObjectForKey:(NSString *)key
{
    return [self.userDefaults objectForKey:key];
}

- (void)setIntegerValue:(NSInteger)integerValue forKey:(NSString *)key
{
    [self.userDefaults setInteger:integerValue forKey:key];
    [self.userDefaults synchronize];
}

- (NSInteger)integerValueForKey:(NSString *)key
{
    return [self.userDefaults integerForKey:key];
}

- (void)setBoolValue:(BOOL)boolValue forKey:(NSString *)key
{
    [self.userDefaults setBool:boolValue forKey:key];
    [self.userDefaults synchronize];
}

- (BOOL)boolValueForKey:(NSString *)key
{
    return [self.userDefaults boolForKey:key];
}


- (BOOL)isReceiveNewMessage
{
    return [self.userDefaults boolForKey:kShouldReceivingMessageSwtich];
}

- (BOOL)isShowMessageDetail
{
    return [self.userDefaults boolForKey:kShouldShowMessageDetailSwitch];
}

- (BOOL)isSoundAvaiable
{
    return [self.userDefaults boolForKey:kRingAlertAvailableSwitch];
}

- (BOOL)isVibrateMode
{
    return [self.userDefaults boolForKey:kVibrateAlertAvailableSwitch];
}

- (BOOL)isNODisturbAtNight
{
    return [self.userDefaults boolForKey:kNoDisturbAtNightSwitch];
}

- (BOOL)isShowHomelandNews
{
    if ([self.userDefaults objectForKey:kShouldShowHomelandMessage])
    {
        return [self.userDefaults boolForKey:kShouldShowHomelandMessage];
    }
    else
    {
        return YES;
    }
}

- (BOOL)isCanSearchMeByPhoneNumberOrName
{
    return [self.userDefaults boolForKey:kFindMeByPhoneNumberSwitch];
}

- (BOOL)isSendMessageByReturnKey
{
    return [self.userDefaults boolForKey:kSendMessageByEnter];
}


// psw
- (BOOL)passwordSwitch
{
    return [self boolValueForKey:kSettingPasswordSwitchKey];
}

- (NSString *)password
{
    return [self stringObjectForKey:kSettingPasswordKey];
}

- (BOOL)touchIDSwitch
{
    return [self boolValueForKey:kSettingPasswordTouchIDOpenKey];
}

- (NSString *)findPasswordQuestion
{
    return [self stringObjectForKey:kSettingFindPasswordQuestionKey];
}

- (NSString *)findPasswordAnswer
{
    return [self stringObjectForKey:kSettingFindPasswordAnswerKey];
}

- (void)setPasswordSwitch:(BOOL)on
{
    [self setBoolValue:on forKey:kSettingPasswordSwitchKey];
}

- (void)setPassword:(NSString *)psw
{
    [self setStringObject:psw forKey:kSettingPasswordKey];
}

- (void)setTouchIDSwitch:(BOOL)on
{
    [self setBoolValue:on forKey:kSettingPasswordTouchIDOpenKey];
}

- (void)setFindPasswordQuestion:(NSString *)q answer:(NSString *)a
{
    [self setStringObject:q forKey:kSettingFindPasswordQuestionKey];
    [self setStringObject:a forKey:kSettingFindPasswordAnswerKey];
}

@end
