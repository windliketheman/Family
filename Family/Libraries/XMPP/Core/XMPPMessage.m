#import "XMPPMessage.h"
#import "XMPPJID.h"
#import "NSXMLElement+XMPP.h"

#import <objc/runtime.h>

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif


@implementation XMPPMessage

+ (void)initialize
{
	// We use the object_setClass method below to dynamically change the class from a standard NSXMLElement.
	// The size of the two classes is expected to be the same.
	// 
	// If a developer adds instance methods to this class, bad things happen at runtime that are very hard to debug.
	// This check is here to aid future developers who may make this mistake.
	// 
	// For Fearless And Experienced Objective-C Developers:
	// It may be possible to support adding instance variables to this class if you seriously need it.
	// To do so, try realloc'ing self after altering the class, and then initialize your variables.
	
	size_t superSize = class_getInstanceSize([NSXMLElement class]);
	size_t ourSize   = class_getInstanceSize([XMPPMessage class]);
	
	if (superSize != ourSize)
	{
		NSLog(@"Adding instance variables to XMPPMessage is not currently supported!");
		exit(15);
	}
}

+ (XMPPMessage *)messageFromElement:(NSXMLElement *)element
{
	object_setClass(element, [XMPPMessage class]);
	
	return (XMPPMessage *)element;
}

+ (XMPPMessage *)message
{
	return [[XMPPMessage alloc] init];
}

+ (XMPPMessage *)messageWithType:(NSString *)type
{
	return [[XMPPMessage alloc] initWithType:type to:nil];
}

+ (XMPPMessage *)messageWithType:(NSString *)type to:(XMPPJID *)to
{
	return [[XMPPMessage alloc] initWithType:type to:to];
}

+ (XMPPMessage *)messageWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid
{
	return [[XMPPMessage alloc] initWithType:type to:jid elementID:eid];
}

+ (XMPPMessage *)messageWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
	return [[XMPPMessage alloc] initWithType:type to:jid elementID:eid child:childElement];
}

+ (XMPPMessage *)messageWithType:(NSString *)type elementID:(NSString *)eid
{
	return [[XMPPMessage alloc] initWithType:type elementID:eid];
}

+ (XMPPMessage *)messageWithType:(NSString *)type elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
	return [[XMPPMessage alloc] initWithType:type elementID:eid child:childElement];
}

+ (XMPPMessage *)messageWithType:(NSString *)type child:(NSXMLElement *)childElement
{
	return [[XMPPMessage alloc] initWithType:type child:childElement];
}

- (id)init
{
	return [self initWithType:nil to:nil elementID:nil child:nil];
}

- (id)initWithType:(NSString *)type
{
	return [self initWithType:type to:nil elementID:nil child:nil];
}

- (id)initWithType:(NSString *)type to:(XMPPJID *)jid
{
	return [self initWithType:type to:jid elementID:nil child:nil];
}

- (id)initWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid
{
	return [self initWithType:type to:jid elementID:eid child:nil];
}

- (id)initWithType:(NSString *)type to:(XMPPJID *)jid elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
	if ((self = [super initWithName:@"message"]))
	{
		if (type)
			[self addAttributeWithName:@"type" stringValue:type];
		
		if (jid)
			[self addAttributeWithName:@"to" stringValue:[jid full]];
		
		if (eid)
			[self addAttributeWithName:@"id" stringValue:eid];
		
		if (childElement)
			[self addChild:childElement];
	}
	return self;
}

- (id)initWithType:(NSString *)type elementID:(NSString *)eid
{
	return [self initWithType:type to:nil elementID:eid child:nil];
}

- (id)initWithType:(NSString *)type elementID:(NSString *)eid child:(NSXMLElement *)childElement
{
	return [self initWithType:type to:nil elementID:eid child:childElement];
}

- (id)initWithType:(NSString *)type child:(NSXMLElement *)childElement
{
	return [self initWithType:type to:nil elementID:nil child:childElement];
}

- (id)initWithXMLString:(NSString *)string error:(NSError *__autoreleasing *)error
{
	if((self = [super initWithXMLString:string error:error])){
		self = [XMPPMessage messageFromElement:self];
	}	
	return self;
}

- (NSString *)body
{
	return [[self elementForName:@"body"] stringValue];
}

- (NSString *)subject{
    return [[self elementForName:@"subject"] stringValue];
}


- (NSString *)thread
{
	return [[self elementForName:@"thread"] stringValue];
}
- (NSString *)messageType{
    return [[self elementForName:@"messageType"] stringValue];
}
- (NSString *)messageId{
    return [[self elementForName:@"messageId"] stringValue];
}
- (NSString *)messageUrl{
    return [[self elementForName:@"messageUrl"] stringValue];

}
- (NSString *)messageThumbnail{
    return [[self elementForName:@"messageThumbnail"] stringValue];

}
- (NSString *)messageDuration{
    return [[self elementForName:@"messageDuration"] stringValue];

}
- (NSString *)messageSize{
    return [[self elementForName:@"messageSize"] stringValue];

}
- (NSString *)messageLocalPath{
    return [[self elementForName:@"messageLocalPath"] stringValue];

}
- (NSString *)messageChatType{
    return [[self elementForName:@"messageChatType"] stringValue];

}
- (NSString *)messageProgress{
    return [[self elementForName:@"messageProgress"] stringValue];

}
- (NSString *)messageBareJidStr{
    return [[self elementForName:@"messageBareJidStr"] stringValue];

}
- (NSString *)messageIsSend{
    return [[self elementForName:@"messageIsSend"] stringValue];

}
- (NSString *)messageIsRead{
    return [[self elementForName:@"messageIsRead"] stringValue];

}
- (NSString *)messageIsSuccess{
    return [[self elementForName:@"messageIsSuccess"] stringValue];
}
- (NSString *)messageFileLocalPath{
    return [[self elementForName:@"messageFileLocalPath"] stringValue];
}

//
- (void)addBody:(NSString *)body
{
    NSXMLElement *bodyElement = [NSXMLElement elementWithName:@"body" stringValue:body];
    [self addChild:bodyElement];
}

- (void)addSubject:(NSString *)subject
{
    NSXMLElement *subjectElement = [NSXMLElement elementWithName:@"subject" stringValue:subject];
    [self addChild:subjectElement];
}

- (void)addThread:(NSString *)thread
{
    NSXMLElement *threadElement = [NSXMLElement elementWithName:@"thread" stringValue:thread];
    [self addChild:threadElement];
}
- (void)addMessageType:(NSString *)messageType{
    NSXMLElement *messageTypeElement = [NSXMLElement elementWithName:@"messageType" stringValue:messageType];
    [self addChild:messageTypeElement];
}
-(void)addMessageId:(NSString*)messageId{
    NSXMLElement *messageIdElement = [NSXMLElement elementWithName:@"messageId" stringValue:messageId];
    [self addChild:messageIdElement];
}
- (void)addmessageUrl:(NSString *)messageUrl{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageUrl" stringValue:messageUrl];
    [self addChild:messageUrlElement];
}
- (void)addmessageThumbnail:(NSString *)messageThumbnail{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageThumbnail" stringValue:messageThumbnail];
    [self addChild:messageUrlElement];
}
- (void)addmessageDuration:(NSString *)messageDuration{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageDuration" stringValue:messageDuration];
    [self addChild:messageUrlElement];
}
- (void)addmessageSize:(NSString*)messageSize{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageSize" stringValue:messageSize];
    [self addChild:messageUrlElement];
}
- (void)addmessageLocalPath:(NSString *)messageLocalPath{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageLocalPath" stringValue:messageLocalPath];
    [self addChild:messageUrlElement];
}
- (void)addmessageChatType:(NSString *)messageChatType{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageChatType" stringValue:messageChatType];
    [self addChild:messageUrlElement];
}
- (void)addmessageProgress:(NSString *)messageProgress{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageProgress" stringValue:messageProgress];
    [self addChild:messageUrlElement];
}
- (void)addmessageBareJidStr:(NSString*)messageBareJidStr{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageBareJidStr" stringValue:messageBareJidStr];
    [self addChild:messageUrlElement];
}
- (void)addmessageIsSend:(NSString *)messageIsSend{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageIsSend" stringValue:messageIsSend];
    [self addChild:messageUrlElement];
}
- (void)addmessageIsRead:(NSString*)messageIsRead{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageIsRead" stringValue:messageIsRead];
    [self addChild:messageUrlElement];
}
- (void)addmessageIsSuccess:(NSString *)messageIsSuccess{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageIsSuccess" stringValue:messageIsSuccess];
    [self addChild:messageUrlElement];
}
- (void)addmessageFileLocalPath:(NSString *)messageFileLocalPath{
    NSXMLElement *messageUrlElement = [NSXMLElement elementWithName:@"messageFileLocalPath" stringValue:messageFileLocalPath];
    [self addChild:messageUrlElement];
}
//
- (BOOL)isChatMessage
{
	return [[[self attributeForName:@"type"] stringValue] isEqualToString:@"chat"];
}

- (BOOL)isChatMessageWithBody
{
	if ([self isChatMessage])
	{
		return [self isMessageWithBody];
	}
	
	return NO;
}

- (BOOL)isErrorMessage
{
    return [[[self attributeForName:@"type"] stringValue] isEqualToString:@"error"];
}

- (NSError *)errorMessage
{
    if (![self isErrorMessage]) {
        return nil;
    }
    
    NSXMLElement *error = [self elementForName:@"error"];
    return [NSError errorWithDomain:@"urn:ietf:params:xml:ns:xmpp-stanzas" 
                               code:[error attributeIntValueForName:@"code"] 
                           userInfo:[NSDictionary dictionaryWithObject:[error compactXMLString] forKey:NSLocalizedDescriptionKey]];

}

- (BOOL)isMessageWithBody
{
	return ([self elementForName:@"body"] != nil);
}
-(BOOL)isOfflineMessageWithBody{
    if ([self isMessageWithBody]) {
        if ([self elementForName:@"delay"]) {
            return YES;
        }
    }
    return NO;
}
@end
