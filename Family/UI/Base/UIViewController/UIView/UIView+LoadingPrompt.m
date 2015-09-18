//
//  UIView+LoadingPrompt.m
//  ennew
//
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "UIView+LoadingPrompt.h"
#import <objc/runtime.h>
#import "LoadingView.h"
#import "MBProgressHUD.h"

#define kLoadingUsingHUD 1

static char loadingViewKey;
static char promptViewKey;

@implementation UIView (LoadingPrompt)

- (void)setLoadingViewProperty:(UIView *)lesoLoadView
{
    objc_setAssociatedObject(self, &loadingViewKey, lesoLoadView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)loadingViewProperty
{
    return objc_getAssociatedObject(self, &loadingViewKey);
}

- (void)setPromptViewProperty:(UIView *)promptView
{
    objc_setAssociatedObject(self, &promptViewKey, promptView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)promptViewProperty
{
    return objc_getAssociatedObject(self, &promptViewKey);
}

- (void)showLoadingViewWithText:(NSString *)text
{
    if (!self.loadingViewProperty)
    {
#if kLoadingUsingHUD
        MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self];
        self.loadingViewProperty = progressHUD;
#else
        self.loadingViewProperty = [[LoadingView alloc] initWithSize:self.bounds.size];
#endif
    }
    
#if kLoadingUsingHUD
    MBProgressHUD *hud = (MBProgressHUD *)self.loadingViewProperty;
    [self addSubview:[self customHUD:hud text:text mode:MBProgressHUDModeIndeterminate]];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(10000.0f);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
#else 
    [(LoadingView *)self.loadingViewProperty showLoadingText:text inView:self];
#endif
}

- (void)hideLoadingView
{
    if (self.loadingViewProperty)
    {
#if kLoadingUsingHUD
        [(MBProgressHUD *)self.loadingViewProperty removeFromSuperview];
#else
        [(LoadingView *)self.loadingViewProperty hide];
#endif
    }
}

- (void)showPromptWithMessage:(NSString *)message
{
    if (!self.promptViewProperty)
    {
        MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self];
        self.promptViewProperty = progressHUD;
    }
    
    MBProgressHUD *hud = (MBProgressHUD *)self.promptViewProperty;
    [self addSubview:[self customHUD:hud text:message mode:MBProgressHUDModeText]];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2.0f);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}

- (MBProgressHUD *)customHUD:(MBProgressHUD *)hud text:(NSString *)text mode:(MBProgressHUDMode)mode
{
    hud.labelText = text;
    hud.mode = mode;
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.labelColor = [UIColor whiteColor];
    hud.margin = 15.0f;
    hud.cornerRadius = 8.0f;
    hud.opacity = 0.8f;
    
    return hud;
}
@end
