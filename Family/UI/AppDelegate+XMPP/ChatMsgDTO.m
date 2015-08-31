//
//  ChatMsgDTO.m
//  jinherIU
//  消息自定义实体
//  Created by hoho108 on 14-5-15.
//  Copyright (c) 2014年 hoho108. All rights reserved.

#import "ChatMsgDTO.h"

@implementation ChatMsgDTO

- (NSString *)systemDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)relativePathToAbsolutePath:(NSString *)filePath
{
    return [[self systemDocumentFolder] stringByAppendingPathComponent:filePath];
}

- (NSString *)localpath
{
    if (NSNotFound == [_localpath rangeOfString:[self systemDocumentFolder]].location)
    {
        NSString *pathTarget = [[self systemDocumentFolder] lastPathComponent];
        NSRange targetRange = [_localpath rangeOfString:pathTarget];
        if (targetRange.location != NSNotFound)
        {
            NSString *relativePath = [_localpath substringFromIndex:targetRange.location + targetRange.length];
            _localpath = [self relativePathToAbsolutePath:relativePath];
        }
    }
    
    return _localpath;
}

@end
