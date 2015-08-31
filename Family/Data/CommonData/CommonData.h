//
//  CommonData.h
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppSetting.h"

#define kIntroductionHasUpdated 1

@interface CommonData : NSObject

+ (instancetype)instance;

+ (void)setMainConfigFile:(NSString *)configFile;

+ (NSString *)serverURL;

+ (NSString *)userAvatarURL;

+ (NSString *)getFileDownloadPath:(NSString *)file;

#pragma mark - User
+ (NSString *)queryLoginUserId;
+ (BOOL)hasUserLogined;

#pragma mark - App Launch
// 第一次安装使用
+ (BOOL)isFirstTimeLaunching;

// 第一次安装使用 或者app更新后第一次使用
+ (BOOL)isNewVersionLaunching;

+ (BOOL)shouldShowAppIntroduction;

+ (void)saveLaunchedAppVersion;

#pragma mark - Theme
+ (void)saveThemeInfo:(NSString *)themeImageName;
+ (NSString *)ThemeInfo;

@property (nonatomic, strong) AppSetting *appSetting;

@end
