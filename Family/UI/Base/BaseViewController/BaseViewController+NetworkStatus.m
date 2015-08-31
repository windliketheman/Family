//
//  BaseViewController+NetworkStatus.m
//  ennew
//
//  Created by jia on 15/8/7.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "BaseViewController+NetworkStatus.h"

#define kIsUsing3GWLAN      @"正在使用3G网络"
#define kThereIsNoNetwork   @"网络不可用"
// #define kNetworkIsAvailable @"正在使用WIFI"

static NetworkStatus initNetworkStatus;

@implementation BaseViewController (NetworkStatus)

- (void)runNetworkMonitoring
{
    // [self resetNetworkStatus];
    
    //网络状态变化监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kNotifyNetworkStatusChanged object:nil];
}

- (BOOL)isNoNetwork
{
    return (NotReachable == [AppNetworkMonitoring shareInstance].networkStatus);
}

- (NetworkStatus)currentNetworkStatus
{
    return [AppNetworkMonitoring shareInstance].networkStatus;
}

- (void)resetNetworkStatus
{
    initNetworkStatus = [AppNetworkMonitoring shareInstance].networkStatus;
}

- (void)networkStatusChanged:(NSNotification *)notification
{
    @synchronized (self)
    {
        AppNetworkMonitoring *monitor = [notification object];
        NSParameterAssert([monitor isKindOfClass:[AppNetworkMonitoring class]]);
        NetworkStatus status = monitor.networkStatus;
        
        if (NotReachable == status)
        {
            if (self.isCurrentViewActived)
            {
                [self promptMessage:kThereIsNoNetwork];
            }
        }
        else
        {
            if (ReachableViaWWAN == status)
            {
                if ([self isCurrentViewActived])
                {
                    [self promptMessage:kIsUsing3GWLAN];
                }
            }
            else
            {
                // do nothing
            }
        }
    }
}

@end
