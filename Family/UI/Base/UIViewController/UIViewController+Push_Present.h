//
//  UIViewController+Push_Present.h
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Push_Present)

// 动作开
- (void)presentModalVC:(UIViewController *)vc;
// 动作开 完成回调
- (void)presentModalVC:(UIViewController *)vc complection:(dispatch_block_t)complection;
// 动作开＋设置导航栏背景＋文字颜色
- (void)presentModalVC:(UIViewController *)vc navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor;
// 动作开＋设置导航栏背景＋文字颜色 完成回调
- (void)presentModalVC:(UIViewController *)vc navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor complection:(dispatch_block_t)complection;

- (void)dismiss;
- (void)dismissWithAnimation:(BOOL)animation;
- (void)dismissComplection:(void (^)(void))callback;
- (void)dismissWithAnimation:(BOOL)animation completion:(void (^)(void))callback;

- (void)pushVC:(UIViewController *)vc;
- (void)pushVC:(UIViewController *)vc withAnimation:(BOOL)animation;
- (void)pop;

@end
