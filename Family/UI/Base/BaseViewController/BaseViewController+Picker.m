//
//  BaseViewController+Picker.m
//  Family
//
//  Created by jia on 15/8/24.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "BaseViewController+Picker.h"
#import "RSKImageCropViewController.h"
#import "AssetPickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation BaseViewController (Picker)

#pragma mark - Cropper Image
- (UIViewController *)imageCropperWithImage:(UIImage *)image
{
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = (id<RSKImageCropViewControllerDelegate>)self;
    return imageCropVC;
}

- (UIViewController *)assetPicker
{
    AssetPickerViewController *picker = [[AssetPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 100000;
    picker.assetsFilter = [ALAssetsFilter allAssets];
    picker.showEmptyGroups = NO;
    picker.pickerDelegate = (id<AssetPickerViewControllerDelegate>)self;
    picker.navigationBar.translucent = YES;
    // [picker setNavigationBarColor:kNavigationBarBGColor];
    // [picker setNavigationBarTitleColor:kNavigationBarTitleColor];
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
        {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 0;
        }
        else
        {
            return YES;
        }
    }];
    
    return picker;
}

- (UINavigationController *)photoCameraPicker
{
    return [self cameraPickerWithMediaTypes:@[(__bridge NSString *)kUTTypeImage]];
}

- (UINavigationController *)videoCameraPicker
{
    return [self cameraPickerWithMediaTypes:@[(__bridge NSString *)kUTTypeMovie]];
}

- (UINavigationController *)cameraPickerWithMediaTypes:(NSArray *)mediaTypes
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
    ipc.allowsEditing = YES;
    ipc.videoQuality = UIImagePickerControllerQualityTypeMedium;
    ipc.videoMaximumDuration = 30.0f;
    
    // kUTTypeImage kUTTypeJPEG kUTTypeMovie kUTTypeMPEG4
    ipc.mediaTypes = mediaTypes;
    
    return ipc;
}

@end
