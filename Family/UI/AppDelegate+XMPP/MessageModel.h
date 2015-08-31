//
//  MessageModel.h
//  ennew
//
//  Created by mijibao on 15/6/12.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject{
    NSString *_id;
}

@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *attachType;
@property (nonatomic, assign) Boolean delay;
@property (nonatomic, assign) NSInteger delivery_status;
@property (nonatomic, strong) NSString *direction;
@property (nonatomic, strong) NSString *familyId;
@property (nonatomic, strong) NSString *familyName;
@property (nonatomic, strong) NSString *familyPhoto;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *hasAttach;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger imageWidth;
@property (nonatomic, strong) NSString *isCalendar;
@property (nonatomic, strong) NSString *isGroup;
@property (nonatomic, strong) NSString *isShowTime;
@property (nonatomic, strong) NSString *listPosition;
@property (nonatomic, strong) NSString *receiveId;
@property (nonatomic, strong) NSString *receivePhone;
@property (nonatomic, strong) NSString *sendAddress;
@property (nonatomic, strong) NSString *sendName;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) NSString *senderPhone;
@property (nonatomic, strong) NSString *senderPhoto;
@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, strong) NSString *uploadProgress;
@property (nonatomic, strong) NSString *voiceLength;
@property (nonatomic, strong) NSString *location;

@end
