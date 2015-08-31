//
//  TabBarViewController.h
//  Family
//
//  Created by jia on 15/8/14.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBarTitleProtocol <NSObject>
- (void)setNavigationBarTitle:(NSString *)title;
@end

typedef void (^NavigationControllerConstructor)(UINavigationController **nc, UIViewController *vc);

@interface TabBarViewController : UITabBarController
@property (nonatomic, strong) UIColor *tabBarItemUnselectedColor;
@property (nonatomic, strong) UIColor *tabBarItemSelectedColor;
@property (nonatomic, strong) NSArray *tabBarItemTitles;
@property (nonatomic, strong) NSArray *tabBarItemImageNames;
@property (nonatomic, strong) NSArray *contentClasses;
@property (nonatomic, assign) UIOffset tabBarItemTitleOffset;

@property (nonatomic, copy) NavigationControllerConstructor navigationControllerConstructor;

- (void)loadChildViewControllers;

@end
