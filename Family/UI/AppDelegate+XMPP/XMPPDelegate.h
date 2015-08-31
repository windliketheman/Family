//
//  XMPPDelegate.h
//  ennew
//
//  Created by mijibao on 15/6/11.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface XMPPDelegate : NSObject<XMPPStreamDelegate>{
    XMPPStream *xmppStream;
    NSString *password;//密码
    BOOL isOpen;//xmpp是否开着
}

@property(nonatomic,readonly)XMPPStream *xmppStream;
+ (id)shareInstance;

//收到消息
- (void)didReceiveMessage:(XMPPMessage *)message;
@end

