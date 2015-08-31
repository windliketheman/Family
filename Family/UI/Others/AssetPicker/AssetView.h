//
//  AssetView.h
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - AssetVideoTitleView

@interface AssetVideoTitleView : UILabel

@end

#pragma mark - TapAssetView

@protocol TapAssetViewDelegate <NSObject>

- (void)touchSelect:(BOOL)select;
- (BOOL)shouldTap;

@end

@interface TapAssetView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<TapAssetViewDelegate> delegate;

@end

#pragma mark - AssetView

@protocol AssetViewDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset *)asset;
- (void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;

@end

@interface AssetView : UIView

@property (nonatomic, weak) id<AssetViewDelegate> delegate;

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end
