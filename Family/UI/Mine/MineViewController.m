//
//  MineViewController.m
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "MineViewController.h"

@implementation MineViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationBarTitle:NSLocalizedString(@"我", nil)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
