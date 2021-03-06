//
//  UIViewController+Picker.m
//  Family
//
//  Created by jia on 15/9/17.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "UIViewController+Picker.h"
// #import "RSKImageCropViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIViewController (Picker)

#if 0
- (UIViewController *)imageCropperWithImage:(UIImage *)image
{
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = (id<RSKImageCropViewControllerDelegate>)self;
    return imageCropVC;
}
#endif

- (AssetPickerViewController *)assetPicker
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

- (void)dispatchAssetsPicker:(void (^)(CTAssetsPickerController *picker))pickerCallback
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            
            // set delegate
            picker.delegate = (id<CTAssetsPickerControllerDelegate>)self;
            picker.showsEmptyAlbums = NO;
            
            // to present picker as a form sheet in iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            if (pickerCallback) {
                pickerCallback(picker);
            }
        });
    }];
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
