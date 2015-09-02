//
//  UploadCore.h
//  Family
//
//  Created by jia on 15/9/1.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UploadFileType)
{
    UploadFileTypeImage = 0,
    UploadFileTypeAudio,
};

typedef void (^UploadItemResult)(NSString *result);
typedef void (^UploadItemsResult)(NSArray *resultArray);

@protocol UploadProtocol <NSObject>
@optional
- (void)uploadResult:(NSString *)result;
- (void)uploadResultByArray:(NSArray *)Return;
@end

@interface UploadCore : NSOperation

@property (nonatomic, weak) id<UploadProtocol> delegate;

- (void)uploadFile:(NSData *)fileData type:(UploadFileType)fileType;
- (void)uploadFile:(NSData *)fileData type:(UploadFileType)fileType result:(UploadItemResult)resultBlock;

/*
 *  @param dataArray 元素类型为NSData
 *  @param typeArray 元素类型为@(UploadFileType)
 */
- (void)uploadFileArray:(NSArray *)dataArray typeArray:(NSArray *)typeArray;
- (void)uploadFileArray:(NSArray *)dataArray typeArray:(NSArray *)typeArray result:(UploadItemsResult)resultBlock;

@end
