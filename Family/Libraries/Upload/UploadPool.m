//
//  UploadPool.m
//  UploadCenter
//
//  Created by jhbjserver on 14-6-10.
//  Copyright (c) 2014年 SM. All rights reserved.
//

#import "UploadPool.h"
#import "UploadTask.h"

#define UIApplicationWillResignActiveNotification @"UIApplicationWillResignActiveNotification"
#define UIApplicationWillTerminateNotification @"UIApplicationWillTerminateNotification"

#define UploadTaskArr @"UploadTaskArr"

@interface UploadPool()

@end

@implementation UploadPool


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:UploadTaskArr]];
        self.taskDic = [NSMutableDictionary dictionary];
        for (NSString *guid in dic.allKeys) {
            [_taskDic setObject:[NSKeyedUnarchiver unarchiveObjectWithData:dic[guid]] forKey:guid];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
        _semaphore = dispatch_semaphore_create(2);
        
    }
    return self;
}
+ (id)shareInstance
{
    static UploadPool *pool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [[UploadPool alloc] init];
    });
    return pool;
}
+ (dispatch_semaphore_t)getSemaphore
{
    UploadPool *pool =[UploadPool shareInstance];
    return pool.semaphore;
}

+ (void)addTask:(UploadTask *)task
{
    //将task进行序列化后，加入字典
    [[[UploadPool shareInstance] taskDic] setObject:task forKey:task.guid];
}

+ (void)delTask:(UploadTask *)task
{
    [[[UploadPool shareInstance] taskDic] removeObjectForKey:task.guid];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActiveNotification:(NSNotification *)notification
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *guid in self.taskDic.allKeys) {
        UploadTask *task = self.taskDic[guid];
        if (task.state == UPSTATE_start || task.state == UPSTATE_wait) {
            task.state = UPSTATE_pause;
        }
        [dic setObject:[NSKeyedArchiver archivedDataWithRootObject:task] forKey:guid];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UploadTaskArr];
}

@end
