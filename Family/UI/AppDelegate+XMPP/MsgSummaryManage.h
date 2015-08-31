//
//  MsgSummaryManage.h
//  jinherIU
//  消息汇总信息管理类
//  Created by mijibao on 14-6-17.
//  Copyright (c) 2014年 hoho108. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgSummary.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "BaseDataManage.h"
#import "ChatMsgDTO.h"

@interface MsgSummaryManage : BaseDataManage

+ (id)shareInstance;

//查询消息汇总
- (MsgSummary *)queryMsgSummaryBychatid:(NSString *)fromId;

//删除消息汇总
- (BOOL)deleteMsgSummary:(NSString *)chatid :(NSInteger)chattype;

//更新消息汇总
- (BOOL)updateMsgSummary:(ChatMsgDTO *)chatmsg :(NSString *)chatid;

//更新消息汇总
- (BOOL)updateMsgSummaryisTop:(MsgSummary*)msgSummay :(NSString *)chatid;

//处理新消息
- (void)dealMsgSummary:(ChatMsgDTO *)chatmsg :(NSString*)chatid;

//查询消息汇总列表
- (NSMutableArray *)getMsgSummaryList:(NSString *)userid;

//更新汇总消息
- (BOOL)updateMsgSummarydata:(MsgSummary *)msg :(NSString *)chatid;

//更新汇总消息数量
-(BOOL)updateMsgSummarycount:(NSInteger)count :(NSString *)chatid;

//更新汇总消息发送状态
-(BOOL)updateMsgSummarystate:(NSInteger)state :(NSString *)msgid;

//更新汇总消息已读状态
-(BOOL)updateMsgSummaryread:(NSString *)isread :(NSString *)msgid;

//清空聊天记录
- (BOOL)clearMsgSummary;

//删除所有聊天记录
- (BOOL)deleteAllMsgSummary;
@end
