//
//  CommonData+AppSetting.h
//  Family
//
//  Created by jia on 15/8/19.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "CommonData.h"

@interface CommonData (AppSetting)

- (BOOL)isReceiveNewMessage;    //接收新消息通知
- (BOOL)isShowMessageDetail;    //关闭时，收到新消息，通知不显示发信人和内容摘要
- (BOOL)isSoundAvaiable;        //声音
- (BOOL)isVibrateMode;          //震动
- (BOOL)isNODisturbAtNight;     //夜间免打扰(22:00~8:00,不震动，不发声)
- (BOOL)isShowHomelandNews;     //家园有更新时，是否出现红点提示
- (BOOL)isCanSearchMeByPhoneNumberOrName;   //是否可以通过手机号、姓名搜索到我
- (BOOL)isSendMessageByReturnKey;   //回车键发送消息

@end
