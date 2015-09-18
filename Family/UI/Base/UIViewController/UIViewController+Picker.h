//
//  UIViewController+Picker.h
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Picker)

#if 0
- (UIViewController *)imageCropperWithImage:(UIImage *)image;
#endif

- (UINavigationController *)assetPicker;
- (UINavigationController *)photoCameraPicker;
- (UINavigationController *)videoCameraPicker;

@end
