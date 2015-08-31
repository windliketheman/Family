//
//  JHCacheManager.h
//  jinherIU
//  缓存管理文件
//  Created by zhangshuaibing on 14-6-10.
//  Copyright (c) 2014年 bing. All rights reserved.

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef enum _JHUserFilePathType {
    JHUserFilePathTypeImage,
    JHUserFilePathTypeAudio,
    JHUserFilePathTypeVideo
} JHUserFilePathType;

@interface JHCacheManager : NSObject {
    
}


//单例入口
+ (JHCacheManager *)sharedInstance;

//获取用户沙盒路径
- (NSString *)getUserPathWithUserid:(NSString *)userid fileType:(JHUserFilePathType)fileType;
//获取大图
- (UIImage *)getImageWithPath:(NSString *)imagePath;
//获取音频文件

//获取视频文件
//删除文件
- (void)deletePhotoByPath:(NSString*)path;
//保存大图并返回路径
- (NSString *)saveImage:(UIImage *)image imageName:(NSString *)imageName userid:(NSString *)userid;


//缓存小图并返回路径
//- (NSString *)saveThumbnaiImage:(UIImage *)image userid:(NSString *)userid;



@end
