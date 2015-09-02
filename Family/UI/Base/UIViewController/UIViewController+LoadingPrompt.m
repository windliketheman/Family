//
//  UIViewController+LoadingPrompt.m
//  ennew
//
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "UIViewController+LoadingPrompt.h"
#import <objc/runtime.h>
#import "UIView+LoadingPrompt.h"
#import "MBProgressHUD.h"

@implementation UIViewController (LoadingPrompt)

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
