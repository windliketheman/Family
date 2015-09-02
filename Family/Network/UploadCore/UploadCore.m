//
//  UploadCore.m
//  Family
//
//  Created by jia on 15/9/1.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UploadCore.h"

// 拼接字符串
static NSString *boundaryStr = @"--";   // 分隔字符串
static NSString *randomIDStr;           // 本次上传标示字符串
static NSString *uploadID;              // 上传(php)脚本中，接收文件字段

@implementation UploadCore

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        randomIDStr = @"itcast";
        uploadID = @"uploadFile";
    }
    return self;
}

#pragma mark - Get Upload URL
- (NSString *)getFileUploadURL
{
    return @"";
}

- (NSString *)createUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    
    return uuid;
}

- (NSString *)fileNameWithType:(UploadFileType)fileType
{
    NSString *name = [self createUUID];
    
    switch (fileType)
    {
        case UploadFileTypeImage:
        {
            return [name stringByAppendingString:@".png"];
            break;
        }
        case UploadFileTypeAudio:
        {
            return [name stringByAppendingString:@".amr"];
            break;
        }
        default:
            return nil;
            break;
    }
}

- (NSString *)fileMimeWithType:(UploadFileType)fileType
{
    switch (fileType)
    {
        case UploadFileTypeImage:
        {
            return @"image/png";
            break;
        }
        case UploadFileTypeAudio:
        {
            return @"audio/amr";
            break;
        }
        default:
            return nil;
            break;
    }
}

#pragma mark - 私有方法
- (NSString *)topStringWithMimeType:(NSString *)mimeType name:(NSString *)uploadName
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"%@%@\n", boundaryStr, randomIDStr];
    [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\n", uploadID, uploadName];
    [strM appendFormat:@"Content-Type: %@\n\n", mimeType];
    
    NSLog(@"%@", strM);
    return [strM copy];
}

- (NSString *)bottomString
{
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendFormat:@"%@%@\n", boundaryStr, randomIDStr];
    [strM appendString:@"Content-Disposition: form-data; name=\"submit\"\n\n"];
    [strM appendString:@"Submit\n"];
    [strM appendFormat:@"%@%@--\n", boundaryStr, randomIDStr];
    
    NSLog(@"%@", strM);
    return [strM copy];
}

- (NSMutableURLRequest *)createRequestWithData:(NSData *)fileData type:(UploadFileType)fileType
{
    // 1> 数据体
    NSString *topString = [self topStringWithMimeType:[self fileMimeWithType:fileType] name:[self fileNameWithType:fileType]];
    
    NSString *bottomString = [self bottomString];
    
    NSMutableData *dataM = [NSMutableData data];
    [dataM appendData:[topString dataUsingEncoding:NSUTF8StringEncoding]];
    [dataM appendData:fileData];
    [dataM appendData:[bottomString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url = [NSURL URLWithString:[self getFileUploadURL]];
    
    // 1. Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10.0f];
    
    // dataM出了作用域就会被释放,因此不用copy
    request.HTTPBody = dataM;
    
    // 2> 设置Request的头属性
    request.HTTPMethod = @"POST";
    
    // 3> 设置Content-Length
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)dataM.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    
    // 4> 设置Content-Type
    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", randomIDStr];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
#if 0
    NSString *localFilePath = @"";
    NSURL *serverURL = [NSURL URLWithString:[self getFileUploadURL]];
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:localFilePath];
    
    // 上传大小
    NSNumber * contentLength = [[[NSFileManager defaultManager] attributesOfItemAtPath:localFilePath error:NULL] objectForKey:NSFileSize];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBodyStream:inputStream];
    [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[contentLength description] forHTTPHeaderField:@"Content-Length"];
#endif
    
    return request;
}

#pragma mark - 上传文件

- (void)uploadFile:(NSData *)fileData type:(UploadFileType)fileType
{
    [self uploadFile:fileData type:fileType result:^(NSString *result) {
        
        if ([self.delegate respondsToSelector:@selector(uploadResult:)])
        {
            [self.delegate uploadResult:result];
        }
    }];
}

- (void)uploadFile:(NSData *)fileData type:(UploadFileType)fileType result:(UploadItemResult)resultBlock
{
    NSMutableURLRequest *request = [self createRequestWithData:fileData type:fileType];
    
    // 3> 连接服务器发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (resultBlock)
        {
            resultBlock([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
}

- (void)uploadFileArray:(NSArray *)dataArray typeArray:(NSArray *)typeArray
{
    [self uploadFileArray:dataArray typeArray:typeArray result:^(NSArray *resultArray) {
        
        if ([self.delegate respondsToSelector:@selector(uploadResultByArray:)])
        {
            [self.delegate performSelector:@selector(uploadResultByArray:) withObject:resultArray];
        }
    }];
}

- (void)uploadFileArray:(NSArray *)dataArray typeArray:(NSArray *)typeArray result:(UploadItemsResult)resultBlock
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger index = 0; index < dataArray.count; ++index)
    {
        NSData *fileData = dataArray[index];
        UploadFileType fileType = [typeArray[index] integerValue];
        
        NSMutableURLRequest *request = [self createRequestWithData:fileData type:fileType];
        __block NSInteger retryTimes = 0;
        __block NSData *resultData = nil;
        
        // 5> 连接服务器发送请求
        dispatch_group_async(group, queue, ^{
            do {
                NSError *err = nil;
                resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
                if (resultData)
                {
                    NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
                    [resultArray addObject:result];
                }
                else
                {
                    retryTimes += 1;
                }
            } while (!resultData && retryTimes < 3); // 请求不成功 并且没超过重试上限，重试本条请求
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (resultBlock)
        {
            resultBlock(resultArray);
        }
    });
}

@end
