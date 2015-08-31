//
//  UploadCenter.h
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadTask.h"

//环境选择
typedef enum : NSUInteger {
    Env_test,
    Env_formal,
    Env_pre,
} Env_Type;

@protocol UploadCenterProtocol <NSObject>

- (void)UploadTaskGuid:(NSString *)guid andTaskEn:(UploadTask *)task;

@end

#define UploadCenterNotification @"UploadCenterNotification"

typedef enum : NSUInteger {
    UPLOAD_start,
    UPLOAD_pause,
    UPLOAD_stop_del,            //停止任务会将任务从队列中删除
} UPLOAD_FUNC;

@interface UploadCenter : NSObject

@property (strong, nonatomic) UploadTask *task;

//回调通知代理
@property (assign, nonatomic)id<UploadCenterProtocol> delegate;

/*
 *  filePath : 本地上传文件路径
 *  guid     : 本上建立的任务标识码
 *  func     : 上传操作 （start，pause，stop）
 **/
- (id)initWithUploadFileWithFilePath:(NSString *)filePath andUploadName:(NSString *)name andGuid:(NSString *)guid withDelegate:(id<UploadCenterProtocol>)delegate;

/*
 *  func     : 上传操作 （start，pause，stop）
 ***/
- (BOOL)setFunc:(UPLOAD_FUNC)func;

/*
 *  filePath : 本地上传文件路径
 *  guid     : 本上建立的任务标识码
 *  func     : 上传操作 （start，pause，stop）
 **/
+ (BOOL)UploadFileWithFilePath:(NSString *)filePath andUploadName:(NSString *)name andGuid:(NSString *)guid andFunc:(UPLOAD_FUNC)func withDelegate:(id<UploadCenterProtocol>)delegate;

/*
 *  获取当前上传任务列表List
 **/
+ (NSArray *)GetCurrentUploadTask;

/**
 *
 *  获取对应该GUID 的任务列表
 ******/
+ (NSArray *)GetCurrentUploadTaskWithGuidList:(NSArray *)guids;

@end
