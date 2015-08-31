//
//  ViewController.h
//  location
//
//  Created by tianlinchun on 15/6/8.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//  百度地图定位

#import "BaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "UIImageView+WebCache.h"
#import "CommonCore.h"

@protocol viewControllerDelegate <NSObject>

@optional
- (void)postMapViewSnapshot:(UIImage *)img withMyPlace:(NSString *)address withMyPlaceJW:(CLLocationCoordinate2D)coordinate;

@end


@interface LocationViewController : BaseViewController

@property(nonatomic)id<viewControllerDelegate>passDelegate;
@property(nonatomic,strong)UIImage *img;

@end

