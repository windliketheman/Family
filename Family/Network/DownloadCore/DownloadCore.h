//
//  DownloadCore.h
//  DownloadCore
//
//  Created by jia on 14-3-14.
//  Copyright (c) 2014年 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadInput.h"

//// NSDictionary *dic = @{@"DownloadURL":op.downloadURL, @"FileSize":[NSString stringWithFormat:@"%ld", fileSize]};
//#define kDownloadCoreNotificationFileSize        @"DownloadCoreNotificationFileSize"
//
//// NSDictionary *dic = @{@"DownloadURL":op.downloadURL, @"DownloadedSize":[NSString stringWithFormat:@"%lld", fileSize]};
//#define kDownloadCoreNotificationDownloadedSize  @"DownloadCoreNotificationDownloadedSize"
//
//// NSDictionary *dic = @{@"DownloadURL":downloadURL, @"DownloadOperationState":[NSString stringWithFormat:@"%d", DownloadOperationStateFailed]};
//#define kDownloadCoreNotificationState           @"DownloadCoreNotificationState"

typedef enum
{
    SystemDirectoryCaches_Default = 0,
    SystemDirectoryDocuments,
    SystemDirectoryTmp
} SystemDirectory;

@protocol DownloadCoreProtocol;
@class DownloadOperation;


@interface DownloadCore : NSObject <DownloadCoreProtocol>

// 最多同时下载任务数
@property (nonatomic, assign) NSUInteger concurrentTasks;

@property (nonatomic, weak) id<DownloadCoreProtocol> delegate;

// query
- (NSUInteger)downloadingNum;
- (NSUInteger)waitingNum;
- (NSString *)filePathWithDownloadURL:(NSString *)url;
- (long long)downloadedSizeOfURL:(NSString *)urlString;

// 下载文件保存到哪？不设则使用内部默认
- (void)setDownloadFolderName:(NSString *)folderName inSystemDirectory:(SystemDirectory)dir;

- (void)startDownload:(DownloadInput *)inputData;
- (void)pauseDownload:(NSString *)downloadURL;
- (void)pauseAllDownload;

- (void)deleteDownload:(NSString *)downloadURL;

@end


@protocol DownloadCoreProtocol <NSObject>

@optional
// 文件大小 请求到了回调
- (void)download:(DownloadInput *)input fileSize:(long long)fileSize;

// 下载的大小 不断回调
- (void)download:(DownloadInput *)input downloadedSize:(long long)downloadedSize;

// 状态 有更新了就回回调
- (void)download:(DownloadInput *)input state:(DownloadOperationState)downloadState;

@end