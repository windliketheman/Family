//
//  UploadPool.h
//  UploadCenter
//
//  Created by jhbjserver on 14-6-10.
//  Copyright (c) 2014年 SM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UploadTask;

@interface UploadPool : NSObject {
}

@property (strong, nonatomic) dispatch_semaphore_t semaphore;
@property (strong, nonatomic) NSMutableDictionary *taskDic;

+ (id)shareInstance;

+ (void)addTask:(UploadTask *)task;

+ (void)delTask:(UploadTask *)task;


+ (dispatch_semaphore_t)getSemaphore;

@end
