//
//  UploadTask.m
//  UploadCenter
//
//  Created by jhbjserver on 14-6-10.
//  Copyright (c) 2014年 SM. All rights reserved.
//

#import "UploadTask.h"

@implementation UploadTask

- (void)setServerUrl:(NSString *)serverUrl
{
    _serverUrl = serverUrl;
    _uploadUrl = serverUrl;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_filePath forKey:@"_filePath"];
    [coder encodeObject:_name forKey:@"_name"];
    [coder encodeObject:_guid forKey:@"_guid"];
    [coder encodeObject:_serverUrl forKey:@"_serverUrl"];
    [coder encodeObject:_message forKey:@"_message"];
    [coder encodeInteger:_fileSize forKey:@"_fileSize"];
    [coder encodeInteger:_updatedSize forKey:@"_updatedSize"];
    [coder encodeInteger:_state forKey:@"_state"];
    [coder encodeInteger:_blockSize forKey:@"_blockSize"];
    [coder encodeObject:_date forKey:@"_date"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.filePath = [coder decodeObjectForKey:@"_filePath"];
        self.name = [coder decodeObjectForKey:@"_name"];
        self.guid = [coder decodeObjectForKey:@"_guid"];
        self.serverUrl = [coder decodeObjectForKey:@"_serverUrl"];
        self.message = [coder decodeObjectForKey:@"_message"];
        self.fileSize = [coder decodeIntegerForKey:@"_fileSize"];
        self.updatedSize = [coder decodeIntegerForKey:@"_updatedSize"];
        self.state = [coder decodeIntegerForKey:@"_state"];
        self.blockSize = [coder decodeIntegerForKey:@"_blockSize"];
        self.date = [coder decodeObjectForKey:@"_date"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@ guid:%@ _state:%lu blockSize:%ldkb Date:%@  :%@", _name,_guid,(unsigned long)_state,(long)_blockSize,_date,_message?:@""];
}

@end
