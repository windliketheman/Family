//
//  UIViewController+Base.m
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+Base.h"
#import "UIImage+Extension.h"

#define Set_Associated_Object(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define Get_Associated_Object(key)        objc_getAssociatedObject(self, key)

@implementation UIViewController (Base)

#pragma mark - Base

static char _firstTimeAppearing;
- (void)setFirstTimeAppearing:(BOOL)firstTimeAppearing
{
    Set_Associated_Object(&_firstTimeAppearing, @(firstTimeAppearing));
}

- (BOOL)isFirstTimeAppearing
{
    return [Get_Associated_Object(&_firstTimeAppearing) boolValue];
}

static char _viewActive;
- (void)setViewActive:(BOOL)viewActive
{
    Set_Associated_Object(&_viewActive, @(viewActive));
}

- (BOOL)isViewActive
{
    return [Get_Associated_Object(&_viewActive) boolValue];
}

static char _navigationBarColor;
- (void)setNavigationBarColor:(UIColor *)navigationBarColor
{
    Set_Associated_Object(&_navigationBarColor, navigationBarColor);
    
    if ([self.navigationController isMemberOfClass:NSClassFromString(@"BaseNavigationController")])
    {
        [self.navigationController performSelector:@selector(setNavigationBarColor:) withObject:self.navigationBarColor];
    }
    else
    {
        // TODO: kUsingTranslucentNavigationBar
        self.navigationController.navigationBar.translucent = kUsingTranslucentNavigationBar;
        [self.navigationController setNavigationBarColor:self.navigationBarColor];
    }
}

- (UIColor *)navigationBarColor
{
    return Get_Associated_Object(&_navigationBarColor);
}

static char _navigationBarTitle;
- (void)setNavigationBarTitle:(NSString *)navigationBarTitle
{
    Set_Associated_Object(&_navigationBarTitle, navigationBarTitle);
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.title = self.navigationBarTitle;
        // self.navigationController.navigationBar.topItem.title = title;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.title = self.navigationBarTitle;
    }
    else
    {
        // 用title的话 导航 返回了 title还是当前title 即影响不仅是本vc
        self.title = self.navigationBarTitle;
    }
}

- (NSString *)navigationBarTitle
{
    if (Get_Associated_Object(&_navigationBarTitle))
    {
        return Get_Associated_Object(&_navigationBarTitle);
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

- (void)setNavigationBarTitleColor:(UIColor *)titleColor
{
    [self setNavigationBarTitleAttributes:@{NSForegroundColorAttributeName:titleColor}];
}

- (UIColor *)navigationBarTitleColor
{
    return [[self navigationBarTitleAttributes] objectForKey:NSForegroundColorAttributeName];
}

- (void)setNavigationBarTitleAttributes:(NSDictionary *)properties
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        if (properties)
        {
            [self.navigationController.navigationBar setTitleTextAttributes:properties];
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

// 设置 导航栏按钮颜色
static char _navigationBarButtonItemColor;
- (void)setNavigationBarButtonItemColor:(UIColor *)itemColor
{
    Set_Associated_Object(&_navigationBarButtonItemColor, itemColor);
}

- (UIColor *)navigationBarButtonItemColor
{
    return Get_Associated_Object(&_navigationBarButtonItemColor);
}

static char _navigationBarLeftButtonItem;
- (void)setNavigationBarLeftButtonItem:(UIBarButtonItem *)leftButtonItem
{
    Set_Associated_Object(&_navigationBarLeftButtonItem, leftButtonItem);
}

- (UIBarButtonItem *)navigationBarLeftButtonItem
{
    if (Get_Associated_Object(&_navigationBarLeftButtonItem))
    {
        return Get_Associated_Object(&_navigationBarLeftButtonItem);
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

static char _navigationBarRightButtonItem;
- (void)setNavigationBarRightButtonItem:(UIBarButtonItem *)rightButtonItem
{
    Set_Associated_Object(&_navigationBarRightButtonItem, rightButtonItem);
}

- (UIBarButtonItem *)navigationBarRightButtonItem
{
    if (Get_Associated_Object(&_navigationBarRightButtonItem))
    {
        return Get_Associated_Object(&_navigationBarRightButtonItem);
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

static char _navigationBarLeftButton;
- (void)setNavigationBarLeftButton:(UIButton *)leftButton
{
    Set_Associated_Object(&_navigationBarLeftButton, leftButton);
}

- (UIButton *)navigationBarLeftButton
{
    return Get_Associated_Object(&_navigationBarLeftButton);
}

static char _navigationBarRightButton;
- (void)setNavigationBarRightButton:(UIButton *)rightButton
{
    Set_Associated_Object(&_navigationBarRightButton, rightButton);
}

- (UIButton *)navigationBarRightButton
{
    return Get_Associated_Object(&_navigationBarRightButton);
}

- (void)setNavigationBarLeftButtonItems:(NSArray *)leftButtonItems
{
    [self removeNavigationBarLeftButtonItems];
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.leftBarButtonItems = leftButtonItems;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.leftBarButtonItems = leftButtonItems;
    }
    else
    {
        // do nothing
    }
}

- (void)removeNavigationBarLeftButtonItems
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = nil;
        
        self.navigationItem.hidesBackButton = YES;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.leftBarButtonItem = nil;
        self.tabBarController.navigationItem.leftBarButtonItems = nil;
        
        self.tabBarController.navigationItem.hidesBackButton = YES;
    }
    else
    {
        // self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)setNavigationBarRightButtonItems:(NSArray *)rightButtonItems
{
    [self removeNavigationBarRightButtonItems];
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.rightBarButtonItems = rightButtonItems;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.rightBarButtonItems = rightButtonItems;
    }
    else
    {
        //
    }
}

- (void)removeNavigationBarRightButtonItems
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else if ([self.parentViewController isKindOfClass:[UITabBarController class]])
    {
        self.tabBarController.navigationItem.rightBarButtonItems = nil;
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        //
    }
}

#pragma mark - Status Bar

- (UIStatusBarStyle)statusBarStyle
{
    return [[UIApplication sharedApplication] statusBarStyle];
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

@end


@implementation UIViewController (Subclass_Rewrite)

#pragma mark - Subclass_Rewrite

// 子类定制样式 导航栏颜色
- (UIColor *)customNavigationBarColor
{
    return [UIColor whiteColor];
}

// 子类定制样式 导航栏标题颜色
- (UIColor *)customNavigationBarTitleColor
{
    return [UIColor blackColor];
}

// 子类定制样式 导航栏左右按钮颜色
- (UIColor *)customNavigationBarButtonItemColor
{
    return [UIColor colorWithRed:0/255.0 green:64/255.0 blue:221/255.0 alpha:1.0];
}

- (void)adjustNavigationBar
{
    [self setNavigationBarColor:[self customNavigationBarColor]];
    [self setNavigationBarTitleColor:[self customNavigationBarTitleColor]];
    [self setNavigationBarButtonItemColor:[self customNavigationBarButtonItemColor]];
    
    [self adjustStatusBarStyleToFitColor:self.navigationBarColor];
    
    [self automaticallyAddBackButton];
}

// 深 return NO 白 return YES
- (BOOL)isLightContentColor:(UIColor *)color
{
    if (!color)
    {
        return YES;
    }
    
    const float grayDegree = 176.0/255.0;
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (red > grayDegree &&
        green > grayDegree &&
        blue > grayDegree)
    {
        // light
        return YES;
    }
    else if (0 == (int)red && 0 == (int)green && 0 == (int)blue && 0 == (int)alpha)
    {
        // clear
        return YES;
    }
    else
    {
        // dark
        return NO;
    }
}

- (void)automaticallyAddBackButton
{
    if (self.parentViewController &&
        [self.parentViewController isKindOfClass:[UINavigationController class]] &&
        self.navigationController.viewControllers.count > 1)
    {
        [self addBackButton];
    }
    else
    {
        [self removeNavigationBarLeftButtonItems];
    }
}

- (void)addBackButton
{
    UIImage *refreshImage = [[UIImage imageNamed:@"navigation_back_white" withTintColor:[self navigationBarButtonItemColor]] originalImage];
    [self addNavigationBarLeftButtonItemWithImage:refreshImage action:@selector(backButtonClicked:)];
}

@end


@implementation UIViewController (NavigationBar)

#pragma mark - NavigationBar

- (void)addNavigationBarLeftButtonItemWithTitle:(NSString *)leftItemTitle action:(SEL)leftItemSelector
{
    [self addNavigationBarLeftButtonItemWithTitle:leftItemTitle color:self.navigationBarButtonItemColor action:leftItemSelector];
}

- (void)addNavigationBarLeftButtonItemWithTitle:(NSString *)leftItemTitle color:(UIColor *)titleColor action:(SEL)leftItemSelector
{
    UIButton *button = nil;
    UIBarButtonItem *item = [self barButtonItemWithTitle:leftItemTitle color:titleColor action:leftItemSelector button:&button];
    
    self.navigationBarLeftButton = button;
    self.navigationBarLeftButtonItem = item;
    
    [self setNavigationBarLeftButtonItems:@[item]];
}

- (void)addNavigationBarRightButtonItemWithTitle:(NSString *)rightItemTitle action:(SEL)rightItemSelector
{
    [self addNavigationBarRightButtonItemWithTitle:rightItemTitle color:self.navigationBarButtonItemColor action:rightItemSelector];
}

- (void)addNavigationBarRightButtonItemWithTitle:(NSString *)rightItemTitle color:(UIColor *)titleColor action:(SEL)rightItemSelector
{
    UIButton *button = nil;
    UIBarButtonItem *item = [self barButtonItemWithTitle:rightItemTitle color:titleColor action:rightItemSelector button:&button];
    
    self.navigationBarRightButton = button;
    self.navigationBarRightButtonItem = item;
    
    [self setNavigationBarRightButtonItems:@[item]];
}

- (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title color:(UIColor *)titleColor action:(SEL)selector button:(UIButton **)button
{
#if 1
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:selector];
    [buttonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                         NSForegroundColorAttributeName : titleColor} forState:UIControlStateNormal];
    
    return buttonItem;
    
#else
    // Global
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
    
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
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size.width = image.size.width * image.scale / [[UIScreen mainScreen] scale];
    frame.size.height = image.size.height * image.scale / [[UIScreen mainScreen] scale];
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:image forState:UIControlStateNormal];
    // [btn setBackgroundColor:[UIColor greenColor]];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    if (button) *button = btn;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (void)addNavigationBarLeftButtonItemWithImage:(UIImage *)leftItemImage action:(SEL)leftItemSelector
{
    UIButton *button = nil;
    UIBarButtonItem *item = [self barButtonItemWithImage:leftItemImage action:leftItemSelector button:&button];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:0];
    space.width = -9.0f;
    
    self.navigationBarLeftButton = button;
    self.navigationBarLeftButtonItem = item;
    
    [self setNavigationBarLeftButtonItems:@[space, item]];
}

- (void)addNavigationBarLeftButtonItemWithImageName:(NSString *)leftItemImageName action:(SEL)leftItemSelector
{
    [self addNavigationBarLeftButtonItemWithImage:[UIImage imageNamed:leftItemImageName withTintColor:self.navigationBarButtonItemColor] action:leftItemSelector];
}

- (void)addNavigationBarRightButtonItemWithImage:(UIImage *)rightItemImage action:(SEL)rightItemSelector
{
    UIButton *button = nil;
    UIBarButtonItem *item = [self barButtonItemWithImage:rightItemImage action:rightItemSelector button:&button];
    
    self.navigationBarRightButton = button;
    self.navigationBarRightButtonItem = item;
    
    [self setNavigationBarRightButtonItems:@[item]];
}

- (void)addNavigationBarRightButtonItemWithImageName:(NSString *)rightItemImageName action:(SEL)rightItemSelector
{
    [self addNavigationBarRightButtonItemWithImage:[UIImage imageNamed:rightItemImageName withTintColor:self.navigationBarButtonItemColor] action:rightItemSelector];
}

- (void)addNavigationBarRightButtonItems:(NSArray *)items types:(NSArray *)types actions:(NSArray *)selectors
{
    if (items.count != types.count || types.count != selectors.count)
    {
        return;
    }
    
    NSMutableArray *buttonItems = [[NSMutableArray alloc] initWithCapacity:items.count];
    for (int i = (int)types.count - 1; i >= 0; --i)
    {
        NSNumber *typeNumber = types[i];
        if (BarButtonItemTypeTitle == typeNumber.unsignedIntegerValue)
        {
            UIBarButtonItem *item = [self barButtonItemWithTitle:items[i] color:self.navigationBarButtonItemColor action:NSSelectorFromString(selectors[i]) button:nil];
            [buttonItems addObject:item];
        }
        else
        {
            UIImage *image;
            if (BarButtonItemTypeImage == typeNumber.unsignedIntegerValue)
            {
                image = items[i];
            }
            else if (BarButtonItemTypeImageName == typeNumber.unsignedIntegerValue)
            {
                image = [UIImage imageNamed:items[i] withTintColor:self.navigationBarButtonItemColor];
            }
            else
            {
                continue;
            }
            UIBarButtonItem *item = [self barButtonItemWithImage:image action:NSSelectorFromString(selectors[i]) button:nil];
            [buttonItems addObject:item];
        }
    }
    
    [self setNavigationBarRightButtonItems:buttonItems];
}

- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end


@implementation UIViewController (Tools)

- (void)adjustStatusBarStyleToFitColor:(UIColor *)navigationBarColor
{
    [[UIApplication sharedApplication] setStatusBarStyle:[self isLightContentColor:navigationBarColor] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent];
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

#pragma mark --- System Folder
- (NSString *)systemDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
