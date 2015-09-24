//
//  UIViewController+Base.h
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BarButtonItemType)
{
    BarButtonItemTypeImage = 0,
    BarButtonItemTypeImageName,
    BarButtonItemTypeTitle,
};

@interface UIViewController (Base)

@property (nonatomic, assign, getter=isFirstTimeAppearing) BOOL firstTimeAppearing;
@property (nonatomic, assign, getter=isViewActive)         BOOL viewActive;

@property (nonatomic, strong) UIColor         *navigationBarColor;
@property (nonatomic, strong) NSString        *navigationBarTitle;
@property (nonatomic, strong) UIColor         *navigationBarTitleColor;
@property (nonatomic, strong) NSDictionary    *navigationBarTitleAttributes;
@property (nonatomic, strong) UIView          *navigationBarTitleView;
@property (nonatomic, strong) UIColor         *navigationBarButtonItemColor;
@property (nonatomic, strong) UIBarButtonItem *navigationBarLeftButtonItem;
@property (nonatomic, strong) UIBarButtonItem *navigationBarRightButtonItem;

// 如果导航栏左右的ButtonItem是用UIButton初始化的，使用下面2个方法可以获得
@property (nonatomic, strong, readonly) UIButton *navigationBarLeftButton;
@property (nonatomic, strong, readonly) UIButton *navigationBarRightButton;

#pragma mark - Status Bar
- (UIStatusBarStyle)statusBarStyle;

#pragma mark - Subview Frame
- (CGRect)scrollViewSubviewRect;
- (CGRect)nonScrollViewSubviewRect;
@end


@interface UIViewController (Subclass_Rewrite)
#pragma mark - For Subclass Rewrite
// 子类定制样式 导航栏颜色
- (UIColor *)customNavigationBarColor;

// 子类定制样式 导航栏标题颜色
- (UIColor *)customNavigationBarTitleColor;

// 子类定制样式 导航栏左右按钮颜色
- (UIColor *)customNavigationBarButtonItemColor;

#pragma mark - 子类覆盖此函数 务必记得调用[super adjustNavigationBar];
- (void)adjustNavigationBar;
@end

@interface UIViewController (NavigationBar)

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
- (void)addNavigationBarRightButtonItems:(NSArray *)items types:(NSArray *)types actions:(NSArray *)selectors;

- (void)removeNavigationBarLeftButtonItems;
- (void)removeNavigationBarRightButtonItems;

#pragma mark - 返回按钮的点击处理，子类如果需要自定义返回的点击，请覆盖此函数，记得调用[super backButtonClicked:sender]
// 子类 定制 返回按钮点击处理
- (void)backButtonClicked:(id)sender;
@end

@interface UIViewController (Tools)

- (void)adjustStatusBarStyleToFitColor:(UIColor *)navigationBarColor;

- (BOOL)isColor:(UIColor *)aColor sameToColor:(UIColor *)bColor;

- (BOOL)isLightContentColor:(UIColor *)color;

- (void)delaySeconds:(float)seconds perform:(dispatch_block_t)block;

- (NSString *)systemDocumentFolder;

@end

