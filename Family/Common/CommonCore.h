//
//  CommonCore.h
//  jinherIU
//  公共方法类
//  Created by mijibao on 14-6-17.
//  Copyright (c) 2014年 Beyondsoft. All rights reserved.

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@interface CommonCore : NSObject
//获取99信息文本大小
+ (CGSize)getNoticeTextSize:(NSString *)message :(NSInteger)fontSize :(NSInteger)maxChatWidth;

//获取文本大小
+ (CGSize)getTextSize:(NSString *)message :(NSInteger)fontSize :(NSInteger)maxChatWidth;

//获取GUID
+ (NSString *)GUID;

//判断文件路径是否存在
+ (BOOL)isExistFile:(NSString *)filePath;

//图片压缩
+ (UIImage *)scale:(UIImage *)image :(CGSize)toSize :(CGFloat)compress;

//转换时间格式
+ (NSString *)showTimeString:(NSString *)time;
//相册时间显示
+ (NSString *)AlbumshowTimeString:(NSString *)time;
//转换时间格式
+ (NSDate *)stringToDate:(NSString *)dateString :(NSString *)format;

//转换时间格式
+ (NSString *)dateToString:(NSDate *)date :(NSString *)format;

//计算时间间隔
+ (NSTimeInterval)timeIntervalBetween:(NSDate *)beginDate and:(NSDate *)endDate;

//图片大小
+ (CGSize)imgScaleSize:(CGSize)size :(CGSize)maxSize;

//查询新路径
+ (NSString *)queryNewFilePath :(NSString *)fileId :(NSString *)fileExtension;

//字符串为空判断
+ (BOOL)isBlankString:(NSString *)string;

//生成时间戳
+(NSString *)createTimestamp;

//时间转时间戳
+ (NSString *)parseParamDate:(NSDate *)date;

//时间戳转时间
+ (NSDate *)getDate:(NSString *)jsonValue;

//颜色图片
+ (UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame;

//获取表情数组
+(NSDictionary *)getemojiDic;


//模型转字典
+ (NSDictionary *)dictionaryWithModel:(id)model;


//判断是否数字
+(BOOL)isPureInt:(NSString*)string;

//头像下载地址(宽度小)
+ (NSString *)downloadHeadImageUrlString:(NSString *)imagePath width:(CGFloat)width;

@property(strong,nonatomic)ASINetworkQueue *networkQueue;

@end