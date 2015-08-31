//
//  AssetGroupTableViewCell.h
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - AssetGroupTableViewCell

@interface AssetGroupTableViewCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end
