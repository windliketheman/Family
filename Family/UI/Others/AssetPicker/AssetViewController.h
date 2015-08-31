//
//  AssetViewController.h
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - AssetViewController

@interface AssetViewController : UITableViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end
