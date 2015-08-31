//
//  JHCacheManager.m
//  jinherIU
//  缓存管理
//  Created by zhangshuaibing on 14-6-10.
//  Copyright (c) 2014年 bing. All rights reserved.
//

#import "JHCacheManager.h"
#import "CommonCore.h"

@interface JHCacheManager () {
    
}
@end

static JHCacheManager *_instance;

@implementation JHCacheManager

#pragma mark - init
//单例入口
+ (JHCacheManager *)sharedInstance
{
    @synchronized(self) {
        if (!_instance) {
            _instance = [[JHCacheManager alloc]init];
        }
    }
    return _instance;
}
//init
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



#pragma mark -- 文件缓存
//获取用户沙盒路径
- (NSString *)getUserPathWithUserid:(NSString *)userid fileType:(JHUserFilePathType)fileType {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //三种文件分别放在不同目录内
    NSArray *fileTypeList = @[@"image",@"audio",@"video"];
    //拼接文件路径
    NSString *docDir = [NSString stringWithFormat:@"%@/%@/%@/%@",[documentPaths objectAtIndex:0],@"Files",userid,[fileTypeList objectAtIndex:fileType]];
    //判断路径是否存在，若不存在则创建
    NSFileManager *filesManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [filesManager fileExistsAtPath:docDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [filesManager createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return docDir;
}
//保存大图并返回路径
- (NSString *)saveImage:(UIImage *)image imageName:(NSString *)imageName userid:(NSString *)userid
{
    //获取图片路径
    NSString *userPath = [self getUserPathWithUserid:userid fileType:JHUserFilePathTypeImage];
    NSString *imagePath = [userPath stringByAppendingPathComponent:imageName];
    //缓存图片到沙盒
    //[UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    [UIImageJPEGRepresentation(image, 0.1)writeToFile:imagePath atomically:YES];
//    ;
    return imagePath;
}

//删除图片
- (void)deletePhotoByPath:(NSString*)path
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *err;
    BOOL isRemove = [fileMgr removeItemAtPath:path error:&err];
    if (!isRemove) {
        NSLog(@"删除文件失败");
    }
}

//获取大图
- (UIImage *)getImageWithPath:(NSString *)imagePath
{
    return [[UIImage alloc]initWithContentsOfFile:imagePath];
}


@end
