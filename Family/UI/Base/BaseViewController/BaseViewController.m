//
//  BaseViewController.m
//  ennew
//
//  Created by mijibao on 15/5/22.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "UINavigationController+Custom.h"

#import "UIViewController+LoadingPrompt.h"

// for button item title
#import "UILabel+Extension.h"
#import "UIImage+Extension.h"

#import "BaseViewController+NetworkStatus.h"

@interface BaseViewController ()
@property (nonatomic, strong) UIColor *navigationBackgroundColor;
@property (nonatomic, strong) NSString *navigationTitle;
@property (nonatomic, strong) UIButton *navigationLeftButton;
@property (nonatomic, strong) UIButton *navigationRightButton;
@property (nonatomic, strong) UIBarButtonItem *navigationLeftButtonItem;
@property (nonatomic, strong) UIBarButtonItem *navigationRightButtonItem;

@property (nonatomic, readwrite, getter=isFirstTimeAppear) BOOL firstTimeAppear;
@property (nonatomic, getter=isCurrentViewActived) BOOL currentViewActived;
@end

@implementation BaseViewController

#pragma mark - Life Cycle
- (instancetype)init
{
    if (self = [super init])
    {
        self.firstTimeAppear = YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO; //不透明的导航栏，原点是否为屏幕左上角，NO：导航栏左下为原点
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self adjustNavigationBarColor];
    [self adjustNavigationBarTitleColor];
    [self adjustStatusBarStyle];
    
    [self customNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.currentViewActived = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.currentViewActived = NO;
    self.firstTimeAppear = NO;
}

#pragma mark - Inner Methods
- (void)addBackButtonAutomatically
{
    if (self.parentViewController &&
        [self.parentViewController isKindOfClass:[UINavigationController class]] &&
        self.navigationController.viewControllers.count > 1)
    {
        [self addBackButton];
    }
    else
    {
        [self removeNavigationBarLeftButtonItem];
    }
}

- (UIImage *)imageWithColor:(UIColor *)uiColor size:(CGSize)size
{
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size = size;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [uiColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (BOOL)shouldAdjustStatusBarStyleToColor:(UIColor *)newBarColor
{
    return ![self isColor:[self navigationBarColor] sameToColor:newBarColor];
}

- (void)adjustStatusBarStyleToColor:(UIColor *)navigationBarColor
{
    [[UIApplication sharedApplication] setStatusBarStyle:[self isLightContentColor:navigationBarColor] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent];
}

// 深 return NO 白 return YES
- (BOOL)isLightContentColor:(UIColor *)color
{
    const float grayDegree = 176.0/255.0;
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (red > grayDegree &&
        green > grayDegree &&
        blue > grayDegree)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isColor:(UIColor *)aColor sameToColor:(UIColor *)bColor
{
    CGFloat aRed, aGreen, aBlue, aAlpha;
    CGFloat bRed, bGreen, bBlue, bAlpha;
    [aColor getRed:&aRed green:&aGreen blue:&aBlue alpha:&aAlpha];
    [bColor getRed:&bRed green:&bGreen blue:&bBlue alpha:&bAlpha];
    
    return (aRed == bRed) && (aGreen == bGreen) && (aBlue == bBlue) && (aAlpha == bAlpha);
}

- (void)delaySeconds:(float)seconds perform:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark - Subclass Rewrite If Need

- (void)adjustNavigationBarColor
{
    [self setNavigationBarColor:kNavigationBarBGColor];
}

- (void)adjustNavigationBarTitleColor
{
    [self setNavigationBarTitleColor:kNavigationBarTitleColor];
}

- (void)adjustStatusBarStyle
{
    [self adjustStatusBarStyleToColor:self.navigationBackgroundColor];
}

- (void)customNavigationBar
{
    [self addBackButtonAutomatically];
}

- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Subview Frame
// 对于scrollView类型，frame和self.view.bounds保持一致
- (CGRect)scrollViewSubviewRect
{
    return self.view.bounds;
    
#if 0
    CGRect scrollViewRect = [[UIScreen mainScreen] bounds];
    if (self.navigationController)
    {
        float navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
        float statusBarHeight     = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        
        BOOL translucent = self.navigationController.navigationBar.translucent;
        if (translucent)
        {
            // 半透明的导航栏，view原点在屏幕左上角
        }
        else
        {
            // 不透明的导航栏，view原点在导航栏左下角
            scrollViewRect.size.height -= (statusBarHeight + navigationBarHeight);
        }
    }
    
    if (self.tabBarController)
    {
        BOOL translucent = self.tabBarController.tabBar.translucent;
        if (translucent)
        {
            // 半透明的切换栏
        }
        else
        {
            // 不透明的导航栏，view原点在导航栏左下角
            scrollViewRect.size.height -= CGRectGetHeight(self.tabBarController.tabBar.bounds);
        }
    }
    
    return scrollViewRect;
#endif
}

// 对于非scrollView类型，半透明时，比较特殊，不透明时其实就是self.view.bounds
- (CGRect)nonScrollViewSubviewRect
{
    CGRect nonScrollViewRect = [[UIScreen mainScreen] bounds];
    if (self.navigationController)
    {
        float navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
        float statusBarHeight     = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        BOOL translucent = self.navigationController.navigationBar.translucent;
        if (translucent)
        {
            // 透明的导航栏，view原点在屏幕左上角
            nonScrollViewRect.origin.y = statusBarHeight + navigationBarHeight;
        }
        
        nonScrollViewRect.size.height -= (statusBarHeight + navigationBarHeight);
    }
    
    if (self.tabBarController)
    {
        // 不透明的导航栏，view原点在导航栏左下角
        nonScrollViewRect.size.height -= CGRectGetHeight(self.tabBarController.tabBar.bounds);
    }
    
    return nonScrollViewRect;
}

#pragma mark - Rotation
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [self.view layoutSubviews];
//}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark - Navigation Bar
#pragma mark --- Back Button
- (void)addBackButton
{
    UIImage *refreshImage = [[UIImage imageNamed:@"navigation_back_white" withTintColor:[self navigationBarTitleColor]] originalImage];
    [self addNavigationBarLeftButtonItemWithImage:refreshImage action:@selector(backButtonClicked:)];
}

#pragma mark --- Getter
- (UIStatusBarStyle)statusBarStyle
{
    return [[UIApplication sharedApplication] statusBarStyle];
}

- (UIColor *)navigationBarColor
{
    return self.navigationBackgroundColor;
}

- (NSString *)navigationBarTitle
{
    if (self.navigationTitle)
    {
        return self.navigationTitle;
    }
    else
    {
        if ([self.parentViewController isKindOfClass:[UINavigationController class]])
        {
            return self.navigationItem.title;
        }
        else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
        {
            return self.tabBarController.navigationItem.title;
        }
        else
        {
            //
        }
    }
    
    return nil;
}

- (UIColor *)navigationBarTitleColor
{
    return [[self navigationBarTitleAttributes] objectForKey:NSForegroundColorAttributeName];
}

- (NSDictionary *)navigationBarTitleAttributes
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        return [self.navigationController.navigationBar titleTextAttributes];
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        // TODO:
        // return [self.tabBarController.navigationController.navigationBar titleTextAttributes];
        return nil;
    }
    else
    {
        //
    }
    
    return nil;
}

- (UIView *)navigationBarTitleView
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        return self.navigationItem.titleView;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        return self.tabBarController.navigationItem.titleView;
    }
    else
    {
        //
    }
    
    return nil;
}

- (UIButton *)navigationBarLeftButton
{
    return self.navigationLeftButton;
}

- (UIButton *)navigationBarRightButton
{
    return self.navigationRightButton;
}

- (UIBarButtonItem *)navigationBarLeftButtonItem
{
    if (self.navigationLeftButtonItem)
    {
        return self.navigationLeftButtonItem;
    }
    else
    {
        if ([self.parentViewController isKindOfClass:[UINavigationController class]])
        {
            return self.navigationItem.leftBarButtonItem;
        }
        else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
        {
            return self.tabBarController.navigationItem.leftBarButtonItem;
        }
        else
        {
            //
        }
    }
    
    return nil;
}

- (UIBarButtonItem *)navigationBarRightButtonItem
{
    if (self.navigationRightButtonItem)
    {
        return self.navigationRightButtonItem;
    }
    else
    {
        if ([self.parentViewController isKindOfClass:[UINavigationController class]])
        {
            return self.navigationItem.rightBarButtonItem;
        }
        else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
        {
            return self.tabBarController.navigationItem.rightBarButtonItem;
        }
        else
        {
            //
        }
    }
    
    return nil;
}

#pragma mark --- Setter
- (void)setNavigationBarColor:(UIColor *)barColor
{
    self.navigationBackgroundColor = barColor;
    
    if ([self.navigationController isKindOfClass:[BaseNavigationController class]])
    {
        BaseNavigationController *baseNavi = (BaseNavigationController *)self.navigationController;
        [baseNavi setNavigationBarColor:barColor];
    }
    else
    {
        self.navigationController.navigationBar.translucent = kUsingTranslucentNavigationBar;
        [self.navigationController setNavigationBarColor:barColor];
    }
}

- (void)setNavigationBarTitle:(NSString *)title
{
    self.navigationTitle = title;
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.title = title;
        //         self.navigationController.navigationBar.topItem.title = title;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.title = title;
    }
    else
    {
        // 用title的话 导航 返回了 title还是当前title 即影响不仅是本vc
        self.title = title;
    }
}

- (void)setNavigationBarTitleColor:(UIColor *)titleColor
{
    [self setNavigationBarTitleAttributes:@{NSForegroundColorAttributeName:titleColor}];
}

- (void)setNavigationBarTitleAttributes:(NSDictionary *)property
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        if (property)
        {
            [self.navigationController.navigationBar setTitleTextAttributes:property];
        }
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        // TODO:
        // [self.tabBarController.navigationController.navigationBar setTitleTextAttributes:property];
    }
    else
    {
        //
    }
}

- (void)setNavigationBarTitleView:(UIView *)titleView
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.titleView = titleView;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.titleView = titleView;
    }
    else
    {
        //
    }
}

- (void)setNavigationBarLeftButtonItem:(UIBarButtonItem *)leftButtonItem
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        if ([leftButtonItem isKindOfClass:[NSArray class]])
        {
            self.navigationItem.leftBarButtonItems = (NSArray *)leftButtonItem;
        }
        else
        {
            self.navigationLeftButtonItem = leftButtonItem;
            self.navigationItem.leftBarButtonItem = leftButtonItem;
        }
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        if ([leftButtonItem isKindOfClass:[NSArray class]])
        {
            self.tabBarController.navigationItem.leftBarButtonItems = (NSArray *)leftButtonItem;
        }
        else
        {
            self.navigationLeftButtonItem = leftButtonItem;
            self.tabBarController.navigationItem.leftBarButtonItem = leftButtonItem;
        }
    }
    else
    {
        // do nothing
    }
}

- (void)removeNavigationBarLeftButtonItem
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.leftBarButtonItem = nil;
        self.tabBarController.navigationItem.hidesBackButton = YES;
    }
    else
    {
        // self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)setNavigationBarRightButtonItem:(UIBarButtonItem *)rightButtonItem
{
    self.navigationRightButtonItem = rightButtonItem;
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    else
    {
        //
    }
}

- (void)removeNavigationBarRightButtonItem
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        //
    }
}

- (void)addNavigationBarLeftButtonItemWithTitle:(NSString *)leftItemTitle color:(UIColor *)titleColor action:(SEL)leftItemSelector
{
    UIButton *button = nil;
    UIBarButtonItem *item = [self barButtonItemWithTitle:leftItemTitle color:titleColor action:leftItemSelector button:&button];
    self.navigationLeftButton = button;
    [self setNavigationBarLeftButtonItem:item];
}

- (void)addNavigationBarRightButtonItemWithTitle:(NSString *)rightItemTitle color:(UIColor *)titleColor action:(SEL)rightItemSelector
{
    UIButton *button = nil;
    UIBarButtonItem *item = [self barButtonItemWithTitle:rightItemTitle color:titleColor action:rightItemSelector button:&button];
    self.navigationRightButton = button;
    [self setNavigationBarRightButtonItem:item];
}

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title color:(UIColor *)titleColor action:(SEL)selector button:(UIButton **)button
{
#if 1
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:[title stringByAppendingString:@" "]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:selector];
    [buttonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                         NSForegroundColorAttributeName : titleColor} forState:UIControlStateNormal];
    
    return buttonItem;
    
    // Global
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
    
#else
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 1000, 24);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    CGSize titleSize = [btn.titleLabel contentTextSize];
    btn.frame = CGRectMake(0.0f, 0.0f, titleSize.width, titleSize.height);
    
    *button = btn;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
#endif
}

- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image action:(SEL)selector button:(UIButton **)button
{
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 23, 23);
    [btn setImage:image forState:UIControlStateNormal];
    // [btn setBackgroundColor:[UIColor greenColor]];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    *button = btn;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (void)addNavigationBarLeftButtonItemWithImage:(UIImage *)leftItemImage action:(SEL)leftItemSelector
{
    UIButton *button = nil;
    UIBarButtonItem *item = [self barButtonItemWithImage:leftItemImage action:leftItemSelector button:&button];
    self.navigationLeftButton = button;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:0];
    space.width = -5.0f;
    
    self.navigationLeftButtonItem = item;
    [self setNavigationBarLeftButtonItem:(UIBarButtonItem *)@[space, item]];
}

- (void)addNavigationBarLeftButtonItemWithImageName:(NSString *)leftItemImageName action:(SEL)leftItemSelector
{
    [self addNavigationBarLeftButtonItemWithImage:[UIImage imageNamed:leftItemImageName] action:leftItemSelector];
}

- (void)addNavigationBarRightButtonItemWithImage:(UIImage *)rightItemImage action:(SEL)rightItemSelector
{
    UIButton *button = nil;
    UIBarButtonItem *item = [self barButtonItemWithImage:rightItemImage action:rightItemSelector button:&button];
    self.navigationRightButton = button;
    [self setNavigationBarRightButtonItem:item];
}

- (void)addNavigationBarRightButtonItemWithImageName:(NSString *)rightItemImageName action:(SEL)rightItemSelector
{
    [self addNavigationBarRightButtonItemWithImage:[UIImage imageNamed:rightItemImageName] action:rightItemSelector];
}

#pragma mark - Present & Push
#pragma mark --- 不定制导航栏
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
    [self presentModalVC:vc withAnimation:animation transitionStyle:style navigationBarColor:kNavigationBarBGColor navigationBarTextColor:kNavigationBarTitleColor complection:complection];
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
        BaseNavigationController *baseNavi = [[BaseNavigationController alloc] initWithRootViewController:vc];
        baseNavi.modalTransitionStyle = style;
        [baseNavi setNavigationBarColor:barColor];
        [baseNavi setNavigationBarTitleColor:barTextColor];
        navi = baseNavi;
    }
    else
    {
        navi = (UINavigationController *)vc;
        navi.modalTransitionStyle = style;
        navi.navigationBar.translucent = kUsingTranslucentNavigationBar;
        // [navi setNavigationBarColor:barColor];
        // [navi setNavigationBarTitleColor:barTextColor];
    }
    
    // 如果新弹出的vc导航栏和之前的导航栏颜色不同 可能需要调整状态栏风格
    if ([self shouldAdjustStatusBarStyleToColor:barColor])
    {
        // 延时执行更改状态栏风格，使状态栏风格改变的时刻和新vc展示动画结束时刻相一致，避免视觉上的生硬变化
        float delaySeconds = animation ? 0.55f : 0.0f;
        [self delaySeconds:delaySeconds perform:^{
            [self adjustStatusBarStyleToColor:barColor];
        }];
    }
    
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

#pragma mark - Loading
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

#pragma mark - Table View
// 隐藏空白单元格
- (void)hideTableViewExtraLines:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
@end
