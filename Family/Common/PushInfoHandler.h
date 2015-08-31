//
//  PushInfoHandler.h
//  ennew
//
//  Created by jia on 15/8/7.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPushInfoNotificationName @"PushInfoNotification"
#define kPushInfoKey              @"PushInfo"

typedef enum
{
    RemotePushTypeMemberJoin = 1,    // 用户家庭成员发生变化时 某某加入
    RemotePushTypeCommentLike,       // 评论点赞时
    RemotePushTypeInvitationRequest, // 有申请或邀请时
    RemotePushTypeMemberExit,        // 家庭成员退出
    RemotePushTypeChatMessage        // 聊天消息
} RemotePushType;

@interface RemotePushInfo : NSObject
@property (nonatomic, strong) NSNumber *type;
@end

@interface PushInfoHandler : NSObject

+ (void)handlePushInfo:(NSDictionary *)info;

@end
