//
//  ChatMsgListManage.h
//  jinherIU
//  消息管理类
//  Created by mijibao on 14-6-17.
//  Copyright (c) 2014年 hoho108. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMsgDTO.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "BaseDataManage.h"

@interface ChatMsgListManage : BaseDataManage

+ (id)shareInstance;
//根据msgid查询消息
- (ChatMsgDTO *)queryChatMsg:(NSString *)msgId withUserID:(NSString *)userID;

//查询消息列表(数组中保存为 ChatMsgDTO 类型)
- (NSMutableArray *)readChatMsgList:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype :(NSInteger)count;

//取所有聊天记录
- (NSMutableArray *)readAllChatMsgList:(NSInteger)chattype;

//删除消息
- (BOOL)deleteChatMsg:(ChatMsgDTO *)msg;

//批量删除消息
- (BOOL)deleteChatMsglist:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype;

//保存消息
- (BOOL)saveChatMsg:(ChatMsgDTO *)msg;

//更新消息发送状态
- (BOOL)saveSendMsgSuccess:(ChatMsgDTO *)msg;

//上传完毕后更新消息
- (BOOL)updateMsgurl:(ChatMsgDTO *)msg;

//更新消息已读状态
//- (BOOL)saveSendMsgRead:(ChatMsgDTO *)msg;
- (BOOL)saveSendMsgRead:(NSMutableArray *)msgArray;

//更新消息本地地址
- (BOOL)saveSendMsgLocalpath:(ChatMsgDTO *)msg;

//清空消息
- (BOOL)clearChatMsglist;

//删除所有消息
- (BOOL)deleteAllChatMsg;

//更新消息
-(BOOL)updateChatMsg:(NSString *)msgid filed:(NSString*)filed content:(NSString *)content;

//查询聊天信息
- (NSMutableArray *)queryChatContent:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype;

//查询消息
- (NSMutableArray *)readMsgList:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype :(NSString *)msgid :(NSInteger)type;

//搜索聊天记录进入聊天获取数据源查询
- (NSMutableArray *)readSearchMsgList:(NSString *)fromuid :(NSString *)touid :(NSInteger)chattype :(NSString *)msgid :(NSInteger)type;

//查询消息列表是否存在
- (BOOL)checkChatMsgList:(NSString *)fromuid :(NSInteger)chattype;

//根据消息id查询userid
- (NSString *)queryUseridWithMsgid:(NSString *)msgid;
// 查找所有未读消息
- (NSMutableArray *)readAllMessageOfNotRead;

@end
