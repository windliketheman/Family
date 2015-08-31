//
//  BaseDataManage.m
//  jinherIU
//  数据库操作基类
//  Created by mijibao on 14-9-18.
//  Copyright (c) 2014年 hoho108. All rights reserved.
//

#import "BaseDataManage.h"

@implementation BaseDataManage

+ (NSString *)databasePath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"ennew.sqlite"];
}

+ (instancetype)instance
{
    static BaseDataManage *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.class sharedQueue];
        __instance = self.new;
    });
    
    return __instance;
}

+ (FMDatabaseQueue *)sharedQueue
{
    static FMDatabaseQueue *__insQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __insQueue = [[FMDatabaseQueue alloc] initWithPath:self.class.databasePath];
    });
    
    return __insQueue;
}
@end
