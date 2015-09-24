//
//  CommonData.m
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "CommonData.h"
#import "CommonDataItemsKeys.h"

#define kIntroductionHasUpdated 1

@implementation CommonData

+ (instancetype)instance
{
    static CommonData *__shareInstance = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{
        __shareInstance = [[super allocWithZone:nil] init];
    });
    return __shareInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _appSetting = [[AppSetting alloc] init];
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if ([self class] == [CommonData class])
    {
        return [[self class] instance];
    }
    else
    {
        return [super allocWithZone:zone];
    }
}

+ (instancetype)alloc
{
    if ([self class] == [CommonData class])
    {
        return [[self class] instance];
    }
    else
    {
        return [super alloc];
    }
}

+ (instancetype)new
{
    if ([self class] == [CommonData class])
    {
        return [[self class] instance];
    }
    else
    {
        return [super new];
    }
}

#ifndef OBJC_ARC_UNAVAILABLE
+ (id)copyWithZone:(struct _NSZone *)zone
{
    if ([self class] == [CommonData class])
    {
        return [[self class] instance];
    }
    else
    {
        return [super copyWithZone:zone];
    }
}
#endif

+ (NSString *)readConfigValue:(NSString *)key
{
    NSString *result = @"";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *configFile = [self readMainConfigFile];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:configFile ofType:@"plist"];
    
    if ([fileManager fileExistsAtPath:plistPath])
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
        
        result=[dict objectForKey:key];
    }
    
    return result;
}

+ (void)setMainConfigFile:(NSString *)configFile
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:configFile forKey:@"CONFIGFILE"];
}

+ (NSString *)readMainConfigFile
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"CONFIGFILE"];
    
}

+ (NSString *)readConfigLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //语言标志
    NSString *languageFlag = [defaults valueForKey:@"userLanguage"];
    
    return languageFlag;
}

+ (NSString *)serverURL
{
    return [NSString stringWithFormat:@"http://%@:%@", [self readConfigValue:@"ServerAddress"], [self readConfigValue:@"ServerPort"]];
}

// 获取文件下载地址
+ (NSString *)getFileDownloadPath:(NSString *)file
{
    return [NSString stringWithFormat:@"%@/EnnewManager/fileDownload?path=%@", [self serverURL], file];
}

// 获取文件上传地址
+ (NSString *)getFileUploadPath
{
    return [NSString stringWithFormat:@"%@/EnnewManager/UploadServlet", [self serverURL]];
}

+ (NSString *)imageUrlString:(NSString *)imagePath
{
    return [NSString stringWithFormat:@"%@/EnnewManager/%@", [self serverURL], imagePath];
}

+ (NSString *)downloadHeadImageUrlString:(NSString *)imagePath width:(CGFloat)width
{
    NSString *str = [NSString stringWithFormat:@"%f",width * 2];
    NSArray *tmpArr = [str componentsSeparatedByString:@"."];
    return [NSString stringWithFormat:@"%@/EnnewManager/fileDownload?path=%@&&fileType=image&width=%@",[self serverURL],imagePath,[tmpArr firstObject]];
}

#pragma mark - User
+ (NSString *)userAvatarURL
{
    return [self getFileDownloadPath:[self queryLoginUserPicture]];
}

+ (BOOL)hasUserLogined
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogined = [userDefaults boolForKey:kIsUserLogin];
    NSUInteger userID = [[self queryLoginUserId] integerValue];
    
    return  isLogined || userID != 0;
}

//查询当前登陆用户
+ (NSString *)queryLoginUserId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:kLoginUserID];
}

//查询当前用户信息
+ (NSDictionary *)queryLoginUserInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"Ennew_%@",[defaults objectForKey:[self queryLoginUserId]]];
    return [defaults objectForKey:key];
}

//存储信息
+ (void)saveLogionUserInfo:(NSDictionary *)dict
{
    NSArray *keys = [dict allKeys];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"Ennew_%@",[defaults objectForKey:[self queryLoginUserId]]];
    
    if (keys.count == 1 && [[keys firstObject] isEqualToString:key]) {
        [defaults setObject:dict forKey:key];
    }else{
        NSMutableDictionary *subDict = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:key] ];
        for (NSString *str in keys) {
            [subDict setValue:dict[str] forKey:str];
        }
        [defaults setObject:subDict forKey:key];
    }
    
    [defaults synchronize];
}

//查询当前登陆用户手机
+ (NSString *)queryLoginUserPhone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:kLoginUserPhone];
}

//查询挡圈登陆用户的密码（md5加密）
+ (NSString *)queryLOginUserPassWord
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:kLoginUserPassword];
}

//查询当前登陆用户昵称
+ (NSString *)queryLoginUserName
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:kLoginUserName];
}

//查询当前登陆用户头像
+ (NSString *)queryLoginUserPicture
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:kLoginUserPicture];
}

#pragma mark - App Launch
// 第一次安装使用
+ (BOOL)isFirstTimeLaunching
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kLaunchedAppVersionKey] ? NO : YES;
}

// 第一次安装使用 或者app更新后第一次使用
+ (BOOL)isNewVersionLaunching
{
    if (![self isFirstTimeLaunching])
    {
        // 不是第一次安装后使用 看记录的版本和当前版本是否一致
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (![[userDefaults objectForKey:kLaunchedAppVersionKey] isEqualToString:AppVersion])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        // 是第一次安装后使用
        return YES;
    }
}

+ (BOOL)shouldShowAppIntroduction
{
    return [self isNewVersionLaunching] && kIntroductionHasUpdated;
}

+ (void)saveLaunchedAppVersion
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:AppVersion forKey:kLaunchedAppVersionKey];
    
    [userDefaults synchronize];
}

#pragma mark - Theme
+ (NSString *)userThemeKey
{
    NSString *userID = [self queryLoginUserId];
    if (userID)
    {
        return [NSString stringWithFormat:@"%@_%@", userID, @"theme"];
    }
    else
    {
        return nil;
    }
}

+ (void)saveThemeInfo:(NSString *)themeImageName
{
    NSString *themeKey = [self userThemeKey] ? [self userThemeKey] : kDefaultThemeKey;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:themeImageName forKey:themeKey];
    
    [userDefaults synchronize];
}

+ (NSString *)ThemeInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userThemeKey = [self userThemeKey];
    if (userThemeKey)
    {
        NSString *theme = [userDefaults objectForKey:userThemeKey];
        if (theme && ![theme isEqualToString:@""])
        {
            return theme;
        }
    }
    
    return [userDefaults objectForKey:kDefaultThemeKey];
}
@end
