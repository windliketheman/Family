//
//  WebViewController.m
//  Family
//
//  Created by jia on 15/8/19.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // fix webview.scroll contentsize is too small bug.
//    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [bgView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:bgView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[super scrollViewSubviewRect]];
    [webView setBackgroundColor:[UIColor whiteColor]];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    // 本地有 则用本地的
    if (self.isLocalFile)
    {
        NSURL *url = [NSURL fileURLWithPath:self.fileURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
    else
    {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.fileURL]]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.webView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.webView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Inner Methods

- (NSString *)getMimeType:(NSString *)fileAbsolutePath error:(NSError *)error
{
    NSString *fullPath = [fileAbsolutePath stringByExpandingTildeInPath];
    NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
    NSURLRequest *fileUrlRequest = [NSURLRequest requestWithURL:fileUrl];
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:fileUrlRequest returningResponse:&response error:&error];
    return [response MIMEType];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoading];
    
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self setNavigationBarTitle:title];
    
#if 0
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function myFunction() { "
     "var field = document.getElementsByName('q')[0];"
     "field.value='朱祁林';"
     "document.forms[0].submit();"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
#endif
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoading];
    
    if (self.isLocalFile)
    {
        return;
    }
    
    if ([self isNoNetwork])
    {
        [self promptMessage:kNetworkUnavailable];
    }
    else
    {
        [self promptMessage:kLoadDataFailed];
    }
}

@end
