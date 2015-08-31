//
//  WhereViewController.h
//  ennew
//
//  Created by jzkj on 15/6/25.
//  Copyright (c) 2015年 ennew. All rights reserved.
//  显示位置

#import "BaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "CommonCore.h"

@interface WhereViewController : BaseViewController <BMKMapViewDelegate, BMKLocationServiceDelegate>

@property(nonatomic)CLLocationCoordinate2D sendCoordinate;//用户坐标
@property(nonatomic)NSString *userNameString;//用户昵称（可选）

//可选
@property(nonatomic)NSArray *CoordinateAndNameDictArr;//字典数组
//key-用户昵称 value-coordinate


@end
