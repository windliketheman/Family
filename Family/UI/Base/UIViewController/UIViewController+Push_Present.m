//
//  UIViewController+Push_Present.m
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+Push_Present.h"
#import "UIViewController+Base.h"
#import "UINavigationController+Custom.h"

@implementation UIViewController (Push_Present)

// 动作开
- (void)presentModalVC:(UIViewController *)vc
{
    [self presentModalVC:vc withAnimation:YES transitionStyle:UIModalTransitionStyleCoverVertical complection:nil];
}

// 动作开 完成回调
- (void)presentModalVC:(UIViewController *)vc complection:(dispatch_block_t)complection
{
    [self presentModalVC:vc withAnimation:YES transitionStyle:UIModalTransitionStyleCoverVertical complection:complection];
}

// 动作开关
- (void)presentModalVC:(UIViewController *)vc withAnimation:(BOOL)animation
{
    [self presentModalVC:vc withAnimation:animation transitionStyle:UIModalTransitionStyleCoverVertical complection:nil];
}

// 动作开关＋动画类型
- (void)presentModalVC:(UIViewController *)vc withAnimation:(BOOL)animation transitionStyle:(UIModalTransitionStyle)style complection:(dispatch_block_t)complection
{
    [self presentModalVC:vc withAnimation:animation transitionStyle:style navigationBarColor:[self navigationBarColor] navigationBarTextColor:[self navigationBarTitleColor] complection:complection];
}

#pragma mark --- 定制导航栏
// 动作开＋设置导航栏背景＋文字颜色
- (void)presentModalVC:(UIViewController *)vc navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor
{
    [self presentModalVC:vc withAnimation:YES navigationBarColor:barColor navigationBarTextColor:barTextColor complection:nil];
}

// 动作开＋设置导航栏背景＋文字颜色 完成回调
- (void)presentModalVC:(UIViewController *)vc navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor complection:(dispatch_block_t)complection
{
    [self presentModalVC:vc withAnimation:YES navigationBarColor:barColor navigationBarTextColor:barTextColor complection:complection];
}

// 动作开关＋设置导航栏背景＋文字颜色
- (void)presentModalVC:(UIViewController *)vc withAnimation:(BOOL)animation navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor complection:(dispatch_block_t)complection
{
    [self presentModalVC:vc withAnimation:animation transitionStyle:UIModalTransitionStyleCoverVertical navigationBarColor:barColor navigationBarTextColor:barTextColor complection:complection];
}

// 动作开关＋动画类型＋设置导航栏背景＋文字颜色
- (void)presentModalVC:(UIViewController *)vc withAnimation:(BOOL)animation transitionStyle:(UIModalTransitionStyle)style navigationBarColor:(UIColor *)barColor navigationBarTextColor:(UIColor *)barTextColor complection:(dispatch_block_t)complection
{
    UINavigationController *navi = nil;
    if (![vc isKindOfClass:[UINavigationController class]])
    {
        // 不是导航器，则把它放入导航器
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    else
    {
        // 是导航器 则使用自身
        navi = (UINavigationController *)vc;
    }
    [navi setModalTransitionStyle:style];
    [navi setNavigationBarColor:barColor];
    [navi setNavigationBarTitleColor:barTextColor];
    
    // 如果新弹出的vc导航栏和之前的导航栏颜色不同 可能需要调整状态栏风格
    [self adjustStatusBarStyleToColor:barColor animated:animation];
    
    [self presentViewController:navi animated:animation completion:^
     {
         if (complection)
         {
             complection();
         }
     }];
}

#pragma mark --- Dismiss
- (void)dismiss
{
    [self dismissComplection:nil];
}

- (void)dismissComplection:(void (^)(void))callback
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if (callback)
        {
            callback();
        }
    }];
}

- (void)dismissWithAnimation:(BOOL)animation
{
    [self dismissViewControllerAnimated:animation completion:nil];
}

- (void)dismissWithAnimation:(BOOL)animation completion:(void (^)(void))callback
{
    [self.navigationController dismissViewControllerAnimated:animation completion:^{
        
        if (callback)
        {
            callback();
        }
    }];
}

#pragma mark --- Push
- (void)pushVC:(UIViewController *)vc
{
    vc.hidesBottomBarWhenPushed = YES;
    
    [self pushVC:vc withAnimation:YES];
}

- (void)pushVC:(UIViewController *)vc withAnimation:(BOOL)animation
{
    [self.navigationController pushViewController:vc animated:animation];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Tool Methods

- (void)adjustStatusBarStyleToColor:(UIColor *)barColor animated:(BOOL)animated
{
    if ([self shouldAdjustStatusBarStyleToColor:barColor])
    {
        // 延时执行更改状态栏风格，使状态栏风格改变的时刻和新vc展示动画结束时刻相一致，避免视觉上的生硬变化
        float delaySeconds = animated ? 0.55f : 0.0f;
        [self delaySeconds:delaySeconds perform:^{
            [self adjustStatusBarStyleToFitColor:barColor];
        }];
    }
}

- (BOOL)shouldAdjustStatusBarStyleToColor:(UIColor *)newBarColor
{
    return ![self isColor:[self navigationBarColor] sameToColor:newBarColor];
}

@end
