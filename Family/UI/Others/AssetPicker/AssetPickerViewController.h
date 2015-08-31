//
//  AssetPickerViewController.h
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol AssetPickerViewControllerDelegate;

@interface AssetPickerViewController : UINavigationController
@property (nonatomic, weak) id<AssetPickerViewControllerDelegate> pickerDelegate;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

@property (nonatomic, strong) NSPredicate *selectionFilter;

@property (nonatomic, assign) BOOL showCancelButton;

@property (nonatomic, assign) BOOL showEmptyGroups;

@property (nonatomic, assign) BOOL isFinishDismissViewController;

- (NSArray *)selectedAssets;

- (BOOL)isSelectedAsset:(ALAsset *)asset;
- (BOOL)shouldSelectAsset:(ALAsset *)asset;
- (void)didSelectAsset:(ALAsset *)asset;
- (void)didDeselectAsset:(ALAsset *)asset;

- (void)cancelPicking;
- (void)finishPicking;

@end

@protocol AssetPickerViewControllerDelegate <NSObject>

- (void)assetPickerController:(AssetPickerViewController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional

- (void)assetPickerControllerDidCancel:(AssetPickerViewController *)picker;

- (void)assetPickerController:(AssetPickerViewController *)picker didSelectAsset:(ALAsset*)asset;

- (void)assetPickerController:(AssetPickerViewController *)picker didDeselectAsset:(ALAsset*)asset;

- (void)assetPickerControllerDidMaximum:(AssetPickerViewController *)picker;

- (void)assetPickerControllerDidMinimum:(AssetPickerViewController *)picker;

@end