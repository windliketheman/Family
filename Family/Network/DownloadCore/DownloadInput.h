//
//  DownloadInput.h
//  DownloadTestDemo
//
//  Created by jia on 14-3-19.
//  Copyright (c) 2014年 iphone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    DownloadOperationStateUnknown = -1,
    DownloadOperationStateFailed,
    DownloadOperationStateDownloading,
    DownloadOperationStateWaiting,
    DownloadOperationStateFinished
} DownloadOperationState;


@interface DownloadInput : NSObject
@property (nonatomic, strong) NSString *downloadURL;

@property (nonatomic, assign) long long downloadedSize;

// 可以增加传入数据 方便外部配合url使用 传入数据在回调时会带出去

@end

