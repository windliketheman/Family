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


@end
