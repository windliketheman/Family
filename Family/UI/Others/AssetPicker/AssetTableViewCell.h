//
//  AssetTableViewCell.h
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - AssetTableViewCell

@protocol AssetTableViewCellDelegate;

@interface AssetTableViewCell : UITableViewCell

@property (nonatomic, weak) id<AssetTableViewCellDelegate> delegate;

@property (nonatomic, assign) CGSize thumbnailSize;

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter itemSpacing:(float)itemSpacing columns:(NSUInteger)columns rowX:(float)rowX;

@end

@protocol AssetTableViewCellDelegate <NSObject>

- (BOOL)isSelectedAsset:(ALAsset *)asset;
- (BOOL)shouldSelectAsset:(ALAsset*)asset;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;

@end
