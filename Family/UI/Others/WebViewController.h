//
//  WebViewController.h
//  Family
//
//  Created by jia on 15/8/19.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSString *fileURL;
@property (nonatomic, readwrite, getter=isLocalFile) BOOL localFile;
@end
