//
//  BaseViewController+Picker.h
//  Family
//
//  Created by jia on 15/8/24.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (Picker)

#pragma mark - Cropper Image
- (UIViewController *)imageCropperWithImage:(UIImage *)image;

- (UINavigationController *)assetPicker;
- (UINavigationController *)photoCameraPicker;
- (UINavigationController *)videoCameraPicker;

@end
