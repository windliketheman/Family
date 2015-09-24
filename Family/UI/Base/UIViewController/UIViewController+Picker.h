//
//  UIViewController+Picker.h
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetPickerViewController.h"
#import "CTAssetsPickerController.h"
#import "CTAssetCheckmark.h"

@interface UIViewController (Picker)

#if 0
- (UIViewController *)imageCropperWithImage:(UIImage *)image;
#endif

- (AssetPickerViewController *)assetPicker;
- (void)dispatchAssetsPicker:(void (^)(CTAssetsPickerController *picker))pickerCallback;
- (UINavigationController *)photoCameraPicker;
- (UINavigationController *)videoCameraPicker;

@end
