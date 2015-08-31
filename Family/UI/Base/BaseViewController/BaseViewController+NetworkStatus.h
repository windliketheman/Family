//
//  BaseViewController+NetworkStatus.h
//  ennew
//
//  Created by jia on 15/8/7.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "BaseViewController.h"
#import "AppNetworkMonitoring.h"
#import "NetworkRequestPromptDefine.h"

@interface BaseViewController (NetworkStatus)

- (void)runNetworkMonitoring;

- (BOOL)isNoNetwork;

- (NetworkStatus)currentNetworkStatus;

@end
