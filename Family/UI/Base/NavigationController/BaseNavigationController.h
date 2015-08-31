//
//  BaseNavigationController.h
//  FileBox
//
//  Created by wind.like.the.man on 14-9-23.
//  Copyright (c) 2014年 OrangeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+Custom.h"

@interface BaseNavigationController : UINavigationController

@property (nonatomic, readwrite) BOOL translucentNavigationBar;       // default: YES
@property (nonatomic, readwrite) BOOL systemTranslucentNavigationBar; // default: NO

@end
