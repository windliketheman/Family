//
//  ChatMsgDTO.h
//  jinherIU
//  消息自定义实体
//  Created by hoho108 on 14-5-15.
//  Copyright (c) 2014年 hoho108. All rights reserved.

#import <Foundation/Foundation.h>
#import "FamilyDataModel.h"
#import "FamilyMembersModel.h"
#import <MapKit/MapKit.h>

typedef enum
{
    ChatMessageSender = 0,
    ChatMessageReceiver
} ChatMessageOwnerType;

@interface ChatMsgDTO : NSObject

@property (strong, nonatomic) NSString *userid;// 当前用户id
@property (strong, nonatomic) NSString *content;//内容
@property (assign, nonatomic) NSInteger filetype;//文件类型
@property (strong, nonatomic) NSString *url;//链接地址
@property (strong, nonatomic) NSString *fromuid;//发送者id
@property (strong, nonatomic) NSString *touid;//接收人id
@property (strong, nonatomic) NSString *name;//名字
@property (assign, nonatomic) NSInteger sendtype;//0 发送  1 接收
@property (strong, nonatomic) NSString *sendtime;//发送时间
@property (strong, nonatomic) NSString *msgid;//消息id
@property (strong, nonatomic) NSDate *orderytime;//发送时间
@property (strong, nonatomic) NSString *thumbnail;//图片缩略图
@property (strong, nonatomic) NSString *localpath;//图片缓存
@property (strong, nonatomic) NSString *duration;//语音播放时长
@property (assign, nonatomic) NSInteger success;//0 失败  1 成功
@property (assign, nonatomic) NSInteger chatType;//聊天类型 0 个人/公众号 1 群组 2 客服 3加入组织申请
@property (strong, nonatomic) NSString *isread;//0 未读  1 已读
@property (strong, nonatomic) NSString *progress;//下载进度
@property (strong, nonatomic) NSString *totalsize;//总大小

@property (strong, nonatomic) NSString *sendcontent;//发送内容
@property (strong, nonatomic) NSString *pushtype;//推送类型
@property (strong, nonatomic) NSString *joinId;//加入组织Id

@property (strong, nonatomic) FamilyMembersModel *sender;
@property (strong, nonatomic) FamilyMembersModel *receiver;
@property (strong, nonatomic) FamilyDataModel *group;
@end
