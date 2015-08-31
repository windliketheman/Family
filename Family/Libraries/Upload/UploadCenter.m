//
//  UploadCenter.m
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UploadCenter.h"
#import "UploadPool.h"
#import "CommonData.h"

@interface UploadCenter()
@property (copy, nonatomic) NSString *downServerUrl;
@end

@implementation UploadCenter

- (id)initWithUploadFileWithFilePath:(NSString *)filePath andUploadName:(NSString *)name andGuid:(NSString *)guid withDelegate:(id<UploadCenterProtocol>)delegate
{
    self = [self init];
    self.delegate = delegate;
    UploadTask *task = [[[UploadPool shareInstance] taskDic] objectForKey:guid];
    if (task) {
        self.task = task;
    } else {
        self.task = [[UploadTask alloc] init];
        _task.filePath = filePath;
        _task.guid = guid;
        _task.updatedSize = 0;
        _task.blockSize = 50 * 1024;
        _task.name = name;
        _task.serverUrl = [self getUrlFromIpFileByKey:@"/EnnewManager/UploadServlet"];
        _downServerUrl = [self getUrlFromIpFileByKey:@"/EnnewManager/fileDownload"];
        _task.date = [NSDate date];
        _task.state = UPSTATE_pause;
        //加入管理池
        [UploadPool addTask:_task];
    }
    return self;
}

- (BOOL)setFunc:(UPLOAD_FUNC)func
{
    switch (func) {
        case UPLOAD_pause:
            if (_task.state != UPSTATE_finish) {
                _task.state = UPLOAD_pause;
            }
            if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
            break;
        case UPLOAD_start: {
            //防止重复上传
            if (_task.state == UPSTATE_start || _task.state == UPSTATE_finish || _task.state == UPSTATE_wait) {
                return NO;
            } else if (_task.isRun) {
                _task.state = UPSTATE_wait;
                if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                    [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
                return YES;
            }
            _task.state = UPSTATE_wait;
            
            if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
            
            @autoreleasepool {
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSData *fileData;
                if ([fileManager fileExistsAtPath:_task.filePath]) {
                    fileData = [NSData dataWithContentsOfFile:_task.filePath];
                    _task.fileSize = fileData.length;
                } else {
                    _task.state = UPSTATE_error;
                    _task.message = @"不存在该文件";
                    if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                        [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
                    _task.isRun = NO;
                    return NO;
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    _task.isRun = YES;
                    dispatch_semaphore_wait([UploadPool getSemaphore], DISPATCH_TIME_FOREVER);
                    if (_task.state == UPSTATE_wait) {
                        _task.state = UPSTATE_start;
                        if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                            [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
                    } else {
                        _task.isRun = NO;
                        dispatch_semaphore_signal([UploadPool getSemaphore]);
                        if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                            [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
                        return ;
                    }
                    if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                        [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
                    while (_task.updatedSize < _task.fileSize) {
                        
                        NSInteger blockSize = _task.blockSize;
                        if (_task.updatedSize + _task.blockSize > _task.fileSize) {
                            blockSize = _task.fileSize - _task.updatedSize;
                        }
                        NSData *data = [fileData subdataWithRange:NSMakeRange(_task.updatedSize, blockSize)];
                        NSURL *url = [NSURL URLWithString:_task.uploadUrl];
                        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                        [request setHTTPMethod:@"POST"];
                        
                        NSMutableString *requestString = [NSMutableString stringWithString:@"{"];
                        [requestString appendString:@"\"fileDTO\":{"];
                        
                        if ([data respondsToSelector:@selector(base64EncodedDataWithOptions:)]) {
                            [requestString appendFormat:@"\"FileDataFromPhone\":\"%@\",",[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
                        } else {
                            [requestString appendFormat:@"\"FileDataFromPhone\":\"%@\",",[data base64Encoding]];
                        }
                        
                        [requestString appendFormat:@"\"FileSize\":%ld,",(long)_task.fileSize];
                        [requestString appendFormat:@"\"IsClient\":true,"];
                        [requestString appendFormat:@"\"StartPosition\":%ld,",(long)_task.updatedSize];
                        [requestString appendFormat:@"\"UploadFileName\":\"%@\"",_task.name];
                        [requestString appendString:@"}"];
                        [requestString appendString:@"}"];
                        
                        [request setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
                        [request setTimeoutInterval:10];
                        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                        NSError *error;
                        NSURLResponse *response;
                        //连续重试三次上传
                        for (int i = 0; i < 3; i++) {
                            if (_task.state == UPSTATE_start) {
                                NSData *con = [NSURLConnection sendSynchronousRequest:request
                                                                    returningResponse:&response
                                                                                error:&error];
                                if (!error) {
                                    NSString *serverUrlFix = [[NSString alloc] initWithData:con encoding:NSUTF8StringEncoding];
                                    serverUrlFix = [serverUrlFix stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                    serverUrlFix = [serverUrlFix stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                                    //                                NSLog(@"serverUrlFix = %@",serverUrlFix);
                                    _task.updatedSize += blockSize;
                                    
                                    serverUrlFix = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)serverUrlFix, NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
                                    _task.uploadUrl = [_task.serverUrl stringByAppendingFormat:@"?fileUrl=%@",serverUrlFix];
                                    _task.downloadUrl = [NSString stringWithFormat:@"%@?fileURL=%@",_downServerUrl,serverUrlFix];
                                    NSLog(@"_task.serverUrl = %@ updataSize %d , blockSize %d , fileSize = %d",_task.uploadUrl,(int)_task.updatedSize,(int)blockSize,(int)_task.fileSize);
                                    
                                    //代理回调
                                    if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                                        [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
                                    }
                                    [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
                                    break;
                                } else {
                                    _task.state = UPSTATE_error;
                                    _task.message = [error description];
                                    //代理回调
                                    if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                                        [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
                                    }
                                    [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
                                    _task.isRun = NO;
                                    dispatch_semaphore_signal([UploadPool getSemaphore]);
                                    return;
                                }
                            } else {
                                _task.isRun = NO;
                                dispatch_semaphore_signal([UploadPool getSemaphore]);
                                return;
                            }
                        }
                        if (_task.updatedSize >= _task.fileSize) {
                            _task.state = UPSTATE_finish;
                            //代理回调
                            if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                                [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
                        }
                        _task.isRun = NO;
                    }
                    dispatch_semaphore_signal([UploadPool getSemaphore]);
                });
            }
        }
            break;
        case UPLOAD_stop_del: {
            _task.state = UPSTATE_stop;
            if (self.delegate && [_delegate respondsToSelector:@selector(UploadTaskGuid:andTaskEn:)]) {
                [self.delegate UploadTaskGuid:_task.guid andTaskEn:_task];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:UploadCenterNotification object:_task];
            //加入管理池
            [UploadPool delTask:_task];
        }
            break;
            
        default:
            break;
    }
    return true;
}
/*
 *  filePath : 本地上传文件路径
 *  guid     : 本上建立的任务标识码
 *  func     : 上传操作
 *
 **********/
+ (BOOL)UploadFileWithFilePath:(NSString *)filePath andUploadName:(NSString *)name andGuid:(NSString *)guid andFunc:(UPLOAD_FUNC)func withDelegate:(id<UploadCenterProtocol>)delegate
{
    UploadCenter *api = [[UploadCenter alloc] initWithUploadFileWithFilePath:filePath andUploadName:name andGuid:guid withDelegate:delegate];
    return [api setFunc:func];
}

+ (NSArray *)GetCurrentUploadTask
{
    return [[[UploadPool shareInstance] taskDic] allValues];
}


+ (NSArray *)GetCurrentUploadTaskWithGuidList:(NSArray *)guids
{
    NSDictionary *dic = [[UploadPool shareInstance] taskDic];
    return [dic objectsForKeys:guids notFoundMarker:nil];
}

- (NSString *)getUrlFromIpFileByKey:(NSString *)key
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [CommonData serverURL], key];
    return urlString;
}

@end
