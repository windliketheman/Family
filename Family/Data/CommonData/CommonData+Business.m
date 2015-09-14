//
//  CommonData+Business.m
//  Family
//
//  Created by jia on 15/9/11.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "CommonData+Business.h"

#define APP_ID @"100"
#define VERSION_CODE @"1"
#define OTA_VERSION  @"1"
#define PID @"1"

@implementation CommonData (Business)

/*
 一个产品ID对应一个可持续升级的客户端发行。
 */
+ (NSString *)appid
{
    return APP_ID;
}

/*
 采用自增正整数，从1开始，每个版本加1。
 */
+ (NSString *)versionCode
{
    return VERSION_CODE;
}

/*
 采用自增正整数，从1开始，每个版本加1。
 */
+ (NSString *)otaVersion
{
    return OTA_VERSION;
}

/*
 每个发行渠道采用一个整数值唯一表示，在整个产品运营过程中pid是不变的。
 */
+ (NSString *)pid
{
    return PID;
}

/*
 平台内用户唯一标识，由服务端根据一定规则生成。
 客户端缺省值0
 */
+ (NSString *)uid
{
    // return @"1";
    return [self queryLoginUserId];
}

/*
 设备型号标识(Device Model ID)
 用来服务端判定终端设备的厂商、型号、硬件配置、基础软件配置等。
 mid获取方法参看checkin接口
 */
+ (NSString *)mid
{
    return @"1";
}

/*
 设备标识(Device ID)
 */
+ (NSString *)did
{
    return @"";
}

/*
 用来实现基本的安全验证，会话ID字符串由服务端根据一定规则生成[REF:服务端详细设计]，客户端和服务端之间传递规则如下：
 如果客户端没有sid，则该header传空字符串；
 如果客户端缓存（内存）有sid，则通过该header传递，由服务端判断是否有效；
 服务端传递了新的sid，客户端需更新缓存（内存）中的sid；
 */
+ (NSString *)sid
{
    return @"1";
}

@end
