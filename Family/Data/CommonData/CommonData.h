//
//  CommonData.h
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppSetting.h"

@interface CommonData : NSObject

@property (nonatomic, strong) AppSetting *appSetting;

+ (instancetype)instance;

+ (void)setMainConfigFile:(NSString *)configFile;

+ (NSString *)serverURL;

#pragma mark - User Info
+ (NSString *)userAvatarURL;
+ (BOOL)hasUserLogined;
+ (NSString *)queryLoginUserId;
+ (NSDictionary *)queryLoginUserInfo;
+ (void)saveLogionUserInfo:(NSDictionary *)dict;
+ (NSString *)queryLoginUserPhone;
+ (NSString *)queryLOginUserPassWord;
+ (NSString *)queryLoginUserName;

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

@end
