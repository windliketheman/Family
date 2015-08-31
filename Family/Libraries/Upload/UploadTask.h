//
//  UploadTask.h
//  UploadCenter
//
//  Created by jhbjserver on 14-6-10.
//  Copyright (c) 2014年 SM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UPSTATE_start,
    UPSTATE_pause,
    UPSTATE_error,
    UPSTATE_finish,
    UPSTATE_wait,
    UPSTATE_stop,
} UPSTATE;

@interface UploadTask : NSObject<NSCoding>


@property (copy, nonatomic) NSString *filePath;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *guid;
@property (copy, nonatomic) NSString *serverUrl;
@property (copy, nonatomic) NSString *uploadUrl;
@property (copy, nonatomic) NSString *downloadUrl;
@property (assign) NSInteger fileSize;
@property (assign) NSInteger updatedSize;
@property (assign) NSInteger blockSize;
@property (assign) UPSTATE state;
@property (copy, nonatomic)     NSString *message;
@property (strong, nonatomic)   NSDate *date;
@property (assign,atomic)       BOOL isRun;

@end
