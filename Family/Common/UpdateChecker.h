//
//  UpdateChecker.h
//  ennew
//  更新检测
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppstoreUpdateInfo : NSObject
@property (nonatomic, assign) BOOL      available;
@property (nonatomic, strong) NSString *updateMessage;
@property (nonatomic, strong) NSURL    *updateURL;
@end

typedef void (^ComplectionBlock)(AppstoreUpdateInfo *updateInfo);
typedef void (^FailureBlock)();

@interface UpdateChecker : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, getter = isInnerPromptUpdate) BOOL innerPromptUpdate;
@property (nonatomic, copy) ComplectionBlock complectionBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

- (void)checkAppID:(NSString *)appID name:(NSString *)appName version:(NSString *)appVersion;

@end

