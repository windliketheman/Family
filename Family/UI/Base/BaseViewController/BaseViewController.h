//
//  BaseViewController.h
//  ennew
//
//  Created by mijibao on 15/5/22.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

#pragma mark - Subclass Rewrite If Need
// 子类定制样式 导航栏颜色
- (void)adjustNavigationBarColor;
// 子类定制样式 导航栏标题颜色
- (void)adjustNavigationBarTitleColor;
// 子类定制样式 导航栏左右按钮颜色
- (void)adjustNavigationBarButtonItemColor;

// 子类定制内容 务必记得调用[super customNavigationBar];
- (void)customNavigationBar;

// 子类 定制 返回按钮点击处理
- (void)backButtonClicked:(id)sender;

#pragma mark - Subview Frame
- (CGRect)scrollViewSubviewRect;
- (CGRect)nonScrollViewSubviewRect;

#pragma mark - Navigation Bar
#pragma mark --- Back Button
- (void)addBackButton;

#pragma mark --- Getter
- (UIStatusBarStyle)statusBarStyle;

- (UIColor *)navigationBarColor;

- (NSString *)navigationBarTitle;
- (UIColor *)navigationBarTitleColor;
- (NSDictionary *)navigationBarTitleAttributes;
- (UIColor *)navigationBarButtonItemColor;
- (UIView *)navigationBarTitleView;

- (UIButton *)navigationBarLeftButton;
- (UIButton *)navigationBarRightButton;
- (UIBarButtonItem *)navigationBarLeftButtonItem;
- (UIBarButtonItem *)navigationBarRightButtonItem;

- (BOOL)isFirstTimeAppear;
- (BOOL)isViewActived;

#pragma mark --- Setter
// 设置 导航栏背景色
- (void)setNavigationBarColor:(UIColor *)barColor;

// 设置 导航栏标题
- (void)setNavigationBarTitle:(NSString *)title;
- (void)setNavigationBarTitleColor:(UIColor *)titleColor;
- (void)setNavigationBarTitleAttributes:(NSDictionary *)property;

// 设置 导航栏按钮颜色
- (void)setNavigationBarButtonItemColor:(UIColor *)itemColor;

// 修改 标题view
- (void)setNavigationBarTitleView:(UIView *)titleView;

// 设置 导航左按钮
- (void)setNavigationBarLeftButtonItem:(UIBarButtonItem *)leftButtonItem;
// 移除 导航左按钮
- (void)removeNavigationBarLeftButtonItem;
// 设置 导航右按钮
- (void)setNavigationBarRightButtonItem:(UIBarButtonItem *)rightButtonItem;
// 移除 导航右按钮
- (void)removeNavigationBarRightButtonItem;

// 使用文字 设置 导航左按钮
- (void)addNavigationBarLeftButtonItemWithTitle:(NSString *)leftItemTitle action:(SEL)leftItemSelector;
- (void)addNavigationBarLeftButtonItemWithTitle:(NSString *)leftItemTitle color:(UIColor *)titleColor action:(SEL)leftItemSelector;
// 使用文字 设置 导航右按钮
- (void)addNavigationBarRightButtonItemWithTitle:(NSString *)rightItemTitle action:(SEL)rightItemSelector;
- (void)addNavigationBarRightButtonItemWithTitle:(NSString *)rightItemTitle color:(UIColor *)titleColor action:(SEL)rightItemSelector;

// 使用图片 设置 导航左按钮
- (void)addNavigationBarLeftButtonItemWithImage:(UIImage *)leftItemImage action:(SEL)leftItemSelector;
- (void)addNavigationBarLeftButtonItemWithImageName:(NSString *)leftItemImageName action:(SEL)leftItemSelector;
// 使用图片 设置 导航右按钮
- (void)addNavigationBarRightButtonItemWithImage:(UIImage *)rightItemImage action:(SEL)rightItemSelector;
- (void)addNavigationBarRightButtonItemWithImageName:(NSString *)rightItemImageName action:(SEL)rightItemSelector;

#pragma mark - Present & Push
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

#pragma mark - Loading
- (void)showLoading;
- (void)showLoading:(NSString *)loadingText;
- (void)showLoadingInView:(UIView *)view;
- (void)showLoading:(NSString *)loadingText inView:(UIView *)view;

- (void)hideLoading;

- (void)promptMessage:(NSString *)message;
- (void)promptMessage:(NSString *)message inView:(UIView *)view;

// 隐藏空白单元格
- (void)hideTableViewExtraLines:(UITableView *)tableView;
@end
