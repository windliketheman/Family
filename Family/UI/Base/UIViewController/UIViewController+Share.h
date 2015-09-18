//
//  UIViewController+Share.h
//  FileBox
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 OrangeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

// for mail
#import <MessageUI/MessageUI.h>

#define kEmailAttachmentNameKey       @"EmailAttachmentName"
#define kEmailAttachmentMimeTypeKey   @"EmailAttachmentMimeType"
#define kEmailAttachmentDataKey       @"EmailAttachmentData"

@interface UIViewController (Share)
<MFMessageComposeViewControllerDelegate,
MFMailComposeViewControllerDelegate>

- (void)sendMailWithSubject:(NSString *)subject
                messageBody:(NSString *)mailBody
                attachments:(NSArray *)attachmentData
               toRecipients:(NSArray *)recepters;

@end
