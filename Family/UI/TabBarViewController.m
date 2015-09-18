//
//  TabBarViewController.m
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "TabBarViewController.h"
#import "UIImage+Extension.h"

@interface TabBarViewController ()
@end

@implementation TabBarViewController

- (void)dealloc
{
    [self removeThemeChangedNotificationObserver];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.tabBarItemTitleOffset = UIOffsetZero;
    
    [self setTabBarBGColor];
    
    [self addThemeChangedNotificationObserver];
    
#if 0
    CGRect buttonRect;
    buttonRect.size = CGSizeMake(kSystemTabBarHeight, kSystemTabBarHeight);
    buttonRect.origin.x = (kScreenWidth - buttonRect.size.width) / 2;
    buttonRect.origin.y = 0.0f;
    UIButton *btn = [[UIButton alloc] initWithFrame:buttonRect];
    btn.backgroundColor = [UIColor redColor];
    [self.tabBar addSubview:btn];
#endif
}

#pragma mark - Inner Methods
- (void)setTabBarBGColor
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f)
    {
        UIImage *buttonImage = [UIImage imageWithColor:RGBCOLOR(248, 248, 248) size:CGSizeMake(1, CGRectGetHeight(self.tabBar.bounds))];
        
        UIImageView *imgv = [[UIImageView alloc] initWithImage:buttonImage];
        imgv.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        imgv.contentMode = UIViewContentModeScaleToFill;
        [[self tabBar] insertSubview:imgv atIndex:1];
        
        // CGSize selectionSize = self.tabBar.selectionIndicatorImage.size;
        
        // 用与背景一样的颜色 把选中的矩形指示图形隐藏
        [self.tabBar setSelectionIndicatorImage:buttonImage];
    }
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Inner Methods
- (UITabBarItem *)tabBarItemAtIndex:(NSUInteger)index withTitle:(NSString *)title titleOffset:(UIOffset)adjustPoint imageNamed:(NSString *)imageName unselectedColor:(UIColor *)unselectedColor selectedColor:(UIColor *)selectedColor
{
    UITabBarItem *tabBarItem;
    UIImage *unselectedImage = [[UIImage imageNamed:imageName withTintColor:unselectedColor] originalImage];
    UIImage *selectedImage = [[UIImage imageNamed:imageName withTintColor:selectedColor] originalImage];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:unselectedImage selectedImage:selectedImage];
    }
    else
    {
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:nil tag:index];
        [tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
    }
    
    [tabBarItem setTag:index];
    [tabBarItem setTitlePositionAdjustment:adjustPoint];
    
    return tabBarItem;
}

- (void)loadChildViewControllers
{
    self.tabBar.tintColor = self.tabBarItemSelectedColor;
    
    const NSUInteger count = MIN(MIN(self.contentClasses.count, self.tabBarItemTitles.count), self.tabBarItemImageNames.count);
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; ++i)
    {
        UITabBarItem *item = [self tabBarItemAtIndex:i withTitle:self.tabBarItemTitles[i] titleOffset:self.tabBarItemTitleOffset imageNamed:self.tabBarItemImageNames[i] unselectedColor:self.tabBarItemUnselectedColor selectedColor:self.tabBarItemSelectedColor];
        
        UIViewController *vc = [[(Class)self.contentClasses[i] alloc] init];
        vc.tabBarItem = item;
        
        UINavigationController *nc = nil;
        if (self.navigationControllerConstructor)
        {
            self.navigationControllerConstructor(&nc, vc);
        }
        else
        {
            nc = [[UINavigationController alloc] initWithRootViewController:vc];
        }
        
        [viewControllers addObject:nc];
    }
    
    self.viewControllers = viewControllers;
}

- (void)addThemeChangedNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kChangeThemeNotification object:nil];
}

- (void)removeThemeChangedNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeThemeNotification object:nil];
}

- (void)themeChanged
{
    [self loadChildViewControllers];
}

@end
