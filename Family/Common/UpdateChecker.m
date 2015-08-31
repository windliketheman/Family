//
//  UpdateChecker.m
//  ennew
//  更新检测
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "UpdateChecker.h"

#define kAppInfoWithID(appID) ([NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appID])

@implementation AppstoreUpdateInfo
@end

@interface UpdateChecker ()
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appVersion;

@property (nonatomic, strong) AppstoreUpdateInfo *updateInfo;
@end

@implementation UpdateChecker

+ (instancetype)shareInstance
{
    static UpdateChecker *_instance = nil;
    
    @synchronized(self)
    {
        if (!_instance)
        {
            _instance = [[super allocWithZone:nil] init];
        }
    }
    
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if ([UpdateChecker class] == self)
        return [self shareInstance];
    
    return [super allocWithZone:zone];
}

- (void)checkAppID:(NSString *)appID name:(NSString *)appName version:(NSString *)appVersion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.appName = appName;
        self.appVersion = appVersion;
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kAppInfoWithID(appID)]];
        
        [self parseJsonData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.updateInfo)
            {
                if (self.complectionBlock)
                {
                    self.complectionBlock(self.updateInfo);
                }
                
                if (self.updateInfo.available && self.isInnerPromptUpdate)
                {
                    [self showAlertWithString:self.updateInfo.updateMessage];
                }
            }
            else
            {
                if (self.failureBlock)
                {
                    self.failureBlock();
                }
            }
        });
    });
}

- (void)parseJsonData:(NSData *)data
{
    if (!data)
    {
        self.updateInfo = nil;
    }
    else
    {
        AppstoreUpdateInfo *updateInfo = [[AppstoreUpdateInfo alloc] init];
        updateInfo.available = NO;
        
        NSError *error;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (json)
        {
            NSArray *results = json[@"results"];
            if (results && [results count])
            {
                NSDictionary *appInfo = results[0];
                NSString *version = appInfo[@"version"];
                
                // @"31.6.7" vs @"31.6.7" : NSOrderedSame
                // @"31.6.7" vs @"31.5.7" : NSOrderedDescending
                // @"31.6.7" vs @"31.6.8" : NSOrderedAscending
                // @"31.6.7" vs @"3.6.8"  : NSOrderedDescending
                // @"31.6.7" vs @"31.6"   : NSOrderedDescending
                // 总结：比较的结果 是按2个字符串里面一部分一部分进行比较
                
                if ([self.appVersion compare:version options:NSNumericSearch] == NSOrderedAscending)
                {
                    NSString *releaseNotes = appInfo[@"releaseNotes"];
                    
                    updateInfo.available = YES;
                    updateInfo.updateMessage = releaseNotes;
                    updateInfo.updateURL = [NSURL URLWithString:appInfo[@"trackViewUrl"]];
                }
            }
        }
        
        self.updateInfo = updateInfo;
    }
}

- (void)showAlertWithString:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.alert)
        {
            [self.alert dismissWithClickedButtonIndex:-1001 animated:NO];
            self.alert = nil;
        }
        
        _alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"\"%@\" 新版发布", self.appName]
                                            message:message
                                           delegate:self
                                  cancelButtonTitle:@"以后再说" // 3
                                  otherButtonTitles:@"下载新版", nil];// 1, 2
        [_alert show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // default cancel btn
    if (0 == buttonIndex)
    {
        // 以后再说
        return;
    }
    else if (1 == buttonIndex)
    {
        [[UIApplication sharedApplication] openURL:self.updateInfo.updateURL];
    }
    else
    {
        return;
    }
}

@end
