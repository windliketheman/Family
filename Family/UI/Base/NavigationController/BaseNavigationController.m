//
//  BaseNavigationController.m
//  FileBox
//
//  Created by wind.like.the.man on 14-9-23.
//  Copyright (c) 2014年 OrangeTeam. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationController+Custom.h"
#import "BaseNavigationBar.h"
#import "BaseViewController.h"
#import "UIImage+Extension.h"

#define kBottomLineGrayValue 176.0/255.0

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)init
{
    if (self = [super initWithNavigationBarClass:[BaseNavigationBar class] toolbarClass:nil])
    {
        self.translucentNavigationBar = YES;
        self.systemTranslucentNavigationBar = NO;
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithNavigationBarClass:[BaseNavigationBar class] toolbarClass:nil])
    {
        self.translucentNavigationBar = YES;
        self.systemTranslucentNavigationBar = NO;
        
        self.viewControllers = @[rootViewController];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Member Methods
- (void)setTranslucentNavigationBar:(BOOL)translucent
{
    _translucentNavigationBar = translucent;
    
    [self.navigationBar setTranslucent:translucent];
}

- (void)setSystemTranslucentNavigationBar:(BOOL)systemTranslucent
{
    _systemTranslucentNavigationBar = systemTranslucent;
    
    [(BaseNavigationBar *)self.navigationBar usingSystemTranslucent:systemTranslucent];
}

#pragma mark - System For Ios6 Later
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[BaseViewController class]])
    {
        return [self.topViewController shouldAutorotate];
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:[BaseViewController class]])
    {
        return [self.topViewController supportedInterfaceOrientations];
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
