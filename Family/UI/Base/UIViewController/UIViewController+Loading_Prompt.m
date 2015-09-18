//
//  UIViewController+Loading_Prompt.m
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+Loading_Prompt.h"
#import <objc/runtime.h>
#import "UIView+LoadingPrompt.h"

@implementation UIViewController (Loading_Prompt)

#pragma mark - Outter Methods

- (void)showLoading
{
    [self showLoading:nil inView:self.view];
}

- (void)showLoading:(NSString *)loadingText
{
    [self showLoading:loadingText inView:self.view];
}

- (void)showLoadingInView:(UIView *)view
{
    [self showLoading:nil inView:view];
}

- (void)showLoading:(NSString *)loadingText inView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showLoadingWithText:loadingText inView:view];
    });
}

- (void)hideLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self hideLoadingView];
    });
}

- (void)promptMessage:(NSString *)message
{
    [self promptMessage:message inView:self.view];
}

- (void)promptMessage:(NSString *)message inView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showPromptView:message inView:view];
    });
}

#pragma mark - Inner Methods
static char loadingViewSuperViewKey;

- (void)setLoadingViewSuperView:(UIView *)lesoLoadView
{
    objc_setAssociatedObject(self, &loadingViewSuperViewKey, lesoLoadView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)loadingViewSuperView
{
    return objc_getAssociatedObject(self, &loadingViewSuperViewKey);
}

- (void)showLoadingWithText:(NSString *)text inView:(UIView *)toView
{
    self.loadingViewSuperView = toView;
    
    // BOOL translucent = self.navigationController.navigationBar.translucent;
    
    [toView showLoadingViewWithText:text];
}

- (void)hideLoadingView
{
    [self.loadingViewSuperView hideLoadingView];
}

- (void)showPromptView:(NSString *)message inView:(UIView *)view
{
    [view showPromptWithMessage:message];
}

- (void)showNoNetworkView
{
    
}

- (void)showNoNetworkViewInView:(UIView *)inView
{
    
}
@end
