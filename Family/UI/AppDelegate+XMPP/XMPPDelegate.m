//
//  XMPPDelegate.m
//  ennew
//
//  Created by mijibao on 15/6/11.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "XMPPDelegate.h"
#import "CommonData.h"
#import "CommonData+AppSetting.h"
#import "ChatMsgDTO.h"
#import "ChatMsgListManage.h"
#import "CommonCore.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate+XMPP.h"

@implementation XMPPDelegate
@synthesize xmppStream;


+ (id)shareInstance {
    static XMPPDelegate *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[XMPPDelegate alloc] init];
    });
    return _sharedInstance;
}

//收到消息
- (void)didReceiveMessage:(XMPPMessage *)message{

    NSString *msg = [[message elementForName:@"body"] stringValue];
    //添加家庭成员
    if([msg isEqualToString:@"family user add"]){
        
    }
    //申请或邀请
    else if([msg isEqualToString:@"apply-invite"]){
        
    }
    //家庭成员退出
    else if([msg isEqualToString:@"familymemberdelete"]){
        
    }
    //家园评论或赞
    else if([CommonCore isPureInt:msg]){
        NSDictionary *newDict = [NSDictionary dictionaryWithObject:msg forKey:@"msgcount"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomelandNumberNotification object:nil userInfo:newDict];
    }
    //聊天消息
    else if (!message.isErrorMessage &&[[msg substringToIndex:1] isEqualToString:@"{"]){
        NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        ChatMsgDTO *msgdto=[self msgdtofromjson:dict];
        
        //将收到消息保存到数据库
        [[ChatMsgListManage shareInstance] saveChatMsg:msgdto];
        
        
        NSDictionary *newDict = [NSDictionary dictionaryWithObject:msgdto forKey:@"newMessage"];

        [[NSNotificationCenter defaultCenter] postNotificationName:kShowNewMessageTipNotification object:nil userInfo:newDict];
        
        // 是否开启免打扰
        if ([[CommonData instance] isNODisturbAtNight])
        {
            if ([self isBetweenFromHour:22 toHour:24] || [self isBetweenFromHour:0 toHour:8])
            {
                
            }
            else
            {
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                [userDefaults setObject:[NSNumber numberWithBool:1] forKey:[[SettingTool sharedSettingTool] isSoundAvaiable]];
//                [userDefaults setObject:[NSNumber numberWithBool:1] forKey:[[SettingTool sharedSettingTool] isVibrateMode]];
//                [userDefaults synchronize];
                
                // 消息震动
                if ([[CommonData instance] isVibrateMode])
                {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // 震动提醒
                }
                else
                {
                    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
                }
                
                if ([[CommonData instance] isSoundAvaiable])
                {
                    AudioServicesPlaySystemSound(1007);
                }
                else
                {
                    AudioServicesDisposeSystemSoundID(1007);
                }
            }
        }
        else
        {
            if ([[CommonData instance] isVibrateMode])
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            else
            {
                if ([[CommonData instance] isSoundAvaiable])
                {
                    AudioServicesPlaySystemSound(1007);
                }
            }
        }
        
        //当前聊天对象
        NSString *chatid = @"";
        @try {
            chatid = [self appDelegate].chatuserid;
        }
        @catch (NSException *exception) {
            NSLog(@"[self appDelegate].chatuserid - error:%@",exception);
        }

        //当前界面
        int nowview = [self appDelegate].nowView;
        if(nowview == 2 ){
            if (msgdto.chatType == 0 && [chatid isEqualToString:msgdto.fromuid]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chatReloadTableView" object:nil userInfo:newDict];
            }
            if (msgdto.chatType == 1 && [chatid isEqualToString:msgdto.touid]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chatReloadTableView" object:nil userInfo:newDict];
            }
        }
    }
}

//解析接收内容
-(ChatMsgDTO *)msgdtofromjson:(NSDictionary *)msg
{
    ChatMsgDTO * result = [[ChatMsgDTO alloc] init];
    NSString *filetype=[msg objectForKey:@"attachType"];
    result.msgid=[CommonCore GUID];
    result.sendtime=[msg objectForKey:@"sendTime"];
    result.sendtype=1;
    result.fromuid=[msg objectForKey:@"sender"];
    result.touid=[msg objectForKey:@"receiveId"];
    NSString *isgroup=[msg objectForKey:@"isGroup"];
    //单聊
    if ([isgroup isEqualToString:@"S"]) {
        result.chatType=0;
    }
    else{
        result.chatType=1;
    }
    result.isread=@"0";
    //文本、表情
    if ([filetype isEqualToString:@"T"]) {
        result.filetype=0;
        result.content=[msg objectForKey:@"textContent"];
    }
    //语音
    else if([filetype isEqualToString:@"S"]){
        result.filetype=1;
        result.url=[msg objectForKey:@"fileUrl"];
        if ([[msg objectForKey:@"voiceLength"] isKindOfClass:[NSString class]]) {
            result.duration=[msg objectForKey:@"voiceLength"];
        }
        else{
            result.duration=[[msg objectForKey:@"voiceLength"] stringValue];
        }
    }
    //图片
    else if([filetype isEqualToString:@"P"]){
        result.filetype=2;
        result.content=[msg objectForKey:@"fileUrl"];
        result.url=[msg objectForKey:@"fileUrl"];
        result.thumbnail=[msg objectForKey:@"fileUrl"];
    }
    //位置
    else if([filetype isEqualToString:@"L"]){
        result.filetype=6;
        result.content=[msg objectForKey:@"sendAddress"];
        result.url=[msg objectForKey:@"fileUrl"];
        NSString *location=[msg objectForKey:@"location"];
        NSArray *locarray=[location componentsSeparatedByString:@","];
        NSString *latitude=locarray[0];
        NSString *longitude=locarray[1];
        result.totalsize=[longitude componentsSeparatedByString:@":"][1];
        result.duration=[latitude componentsSeparatedByString:@":"][1];
    }
    else{
        result.content=[msg objectForKey:@"textContent"];
    }
    return result;
}

- (AppDelegate *)appDelegate {
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

// 是否 22:00 ~ 8:00
/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *fromData = [self getCustomDateWithHour:fromHour];
    NSDate *toData = [self getCustomDateWithHour:toHour];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:fromData] == NSOrderedDescending && [currentDate compare:toData] == NSOrderedAscending)
    {
        NSLog(@"该时间在 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
        return YES;
    }
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}
@end
