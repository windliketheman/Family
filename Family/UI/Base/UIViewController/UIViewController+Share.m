//
//  UIViewController+Share.m
//  FileBox
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 OrangeTeam. All rights reserved.
//

#import "UIViewController+Share.h"
#import "UIViewController+Push_Present.h"

@implementation UIViewController (Share)

#pragma mark --- SMS
- (void)showSMSPicker
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass)
    {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText])
        {
            [self displaySMSComposerSheet];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""message:@"设备不支持短信功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        //
    }
}
- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *smsBody = [NSString stringWithFormat:@"我分享了文件给您，地址是%@", @""];
    picker.body = smsBody;
    
    [self presentModalVC:picker];
}

#pragma mark --- Send Mail
- (void)sendMailWithSubject:(NSString *)subject
                messageBody:(NSString *)mailBody
                attachments:(NSArray *)attachmentData
               toRecipients:(NSArray *)recepters
{
    MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
    emailer.mailComposeDelegate = self;
    [emailer setSubject:subject];
    [emailer setMessageBody:mailBody isHTML:NO];
    // [emailer setMessageBody:@"<HTML><B>Hello, Joe!</B><BR/>What do you know?</HTML>" isHTML:YES];
    [emailer setToRecipients:recepters];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        emailer.modalPresentationStyle = UIModalPresentationPageSheet;
    }
    
    //    [emailer setToRecipients:toRecipients];
    //    [emailer setCcRecipients:ccRecipients];
    //    [emailer setBccRecipients:bccRecipients];
    
    if (attachmentData && attachmentData.count > 0)
    {
        for (NSDictionary *attachment in attachmentData)
        {
            [emailer addAttachmentData:[attachment objectForKey:kEmailAttachmentDataKey]
                              mimeType:[attachment objectForKey:kEmailAttachmentMimeTypeKey]
                              fileName:[attachment objectForKey:kEmailAttachmentNameKey]];
        }
    }
    
    // @"image/jpeg", xxx.jpg; @"image/png",  xxx.png; @"text/txt", xxx.txt; @"text/doc", xxx.doc; @"file/pdf", xxx.pdf
    //
    
    [self presentModalVC:emailer];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = NSLocalizedString(@"邮件发送取消", nil);
            break;
        case MFMailComposeResultSaved:
            msg = NSLocalizedString(@"邮件保存成功", nil);
            break;
        case MFMailComposeResultSent:
            msg = NSLocalizedString(@"邮件发送成功", nil);
            break;
        case MFMailComposeResultFailed:
            msg = NSLocalizedString(@"邮件发送失败", nil);
            break;
        default:
            break;
    }
    
    // [self promptMsg:msg];
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         // do something
     }];
}

@end
