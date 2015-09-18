//
//  UIViewController+Loading_Prompt.h
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Loading_Prompt)

- (void)showLoading;
- (void)showLoading:(NSString *)loadingText;
- (void)showLoadingInView:(UIView *)view;
- (void)showLoading:(NSString *)loadingText inView:(UIView *)view;

- (void)hideLoading;

- (void)promptMessage:(NSString *)message;
- (void)promptMessage:(NSString *)message inView:(UIView *)view;

@end
