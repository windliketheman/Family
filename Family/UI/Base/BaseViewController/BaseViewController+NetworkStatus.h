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

@protocol NetworkMonitoringProtocol <NSObject>

- (void)networkStatusChanged:(NSNotification *)notification;

@end

@interface BaseViewController (NetworkStatus) <NetworkMonitoringProtocol>

/* 添加网络监控
 网络变化后会回调NetworkMonitoringProtocol代理中的方法
 - (void)networkStatusChanged:(NSNotification *)notification
 当网络切换成非wifi状态时，会自动弹出弱提示信息
 子类可以重写以上函数，如想保留上述功能，请在函数顶端加入
 [super networkStatusChanged:notification];
 */
- (void)addNetworkMonitoring;

// 移除网络监控
- (void)removeNetworkMonitoring;

- (BOOL)isNoNetwork;

- (NetworkStatus)currentNetworkStatus;

@end
