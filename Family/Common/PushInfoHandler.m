//
//  PushInfoHandler.m
//  ennew
//
//  Created by jia on 15/8/7.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "PushInfoHandler.h"

@implementation RemotePushInfo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // do nothing
}
@end

@implementation PushInfoHandler

+ (void)handlePushInfo:(NSDictionary *)info
{
    NSLog(@"Remote Notification: %@", [info description]);
    
    RemotePushInfo *pushInfo = [[RemotePushInfo alloc] init];
    [pushInfo setValuesForKeysWithDictionary:info];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPushInfoNotificationName object:nil userInfo:@{kPushInfoKey:pushInfo}];
}

@end
