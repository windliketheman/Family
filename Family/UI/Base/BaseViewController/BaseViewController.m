//
//  BaseViewController.m
//  ennew
//
//  Created by mijibao on 15/5/22.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

#pragma mark - Life Cycle
- (instancetype)init
{
    if (self = [super init])
    {
        self.firstTimeAppearing = YES;
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
    
    [self adjustNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.viewActive = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.viewActive = NO;
    self.firstTimeAppearing = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom

// 子类定制样式 导航栏颜色
- (UIColor *)customNavigationBarColor
{
    return [UIColor clearColor];
}

// 子类定制样式 导航栏标题颜色
- (UIColor *)customNavigationBarTitleColor
{
    return kNavigationBarTitleColor;
}

// 子类定制样式 导航栏左右按钮颜色
- (UIColor *)customNavigationBarButtonItemColor
{
    return kNavigationBarItemColor;
}

#pragma mark - Rotation
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [self.view layoutSubviews];
//}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}


@end
