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

@end
