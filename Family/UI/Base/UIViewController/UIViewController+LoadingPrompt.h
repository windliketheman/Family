//
//  UIViewController+LoadingPrompt.h
//  ennew
//
//  Created by jia on 15/7/24.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LoadingPrompt)

- (void)showLoadingWithText:(NSString *)text inView:(UIView *)toView;

- (void)hideLoadingView;

- (void)showPromptView:(NSString *)message inView:(UIView *)view;

- (void)showNoNetworkView;
- (void)showNoNetworkViewInView:(UIView *)inView;

@end
