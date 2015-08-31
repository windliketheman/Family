//
//  AppDelegate+XMPP.h
//  Family
//
//  Created by jia on 15/8/13.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "XMPPDelegate.h"

// chat data emtity
// #import "MessageModel.h"
// #import "ChatMsgDTO.h"

@protocol ChatDelegate <NSObject>

- (void)friendStatusChange:(AppDelegate *)appD Presence:(XMPPPresence *)presence;
- (void)getNewMessage:(AppDelegate *)appD Message:(XMPPMessage *)message;


@end

@interface AppDelegate (XMPP)
@property (nonatomic, strong) id<ChatDelegate> chatDelegate;
// 当前聊天对象
@property (strong, nonatomic) NSString *chatuserid;

// 当前视图：0：其他，1-消息，2-单聊 3-微分享界面 7-需要支持横屏的界面 8-分享消息界面
@property (assign, nonatomic) int nowView;

@end
