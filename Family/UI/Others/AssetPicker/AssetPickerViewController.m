//
//  AssetPickerViewController.m
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "AssetPickerViewController.h"
#import "AssetGroupViewController.h"
#import "AssetPickerDefine.h"

@interface AssetPickerViewController ()
@property (nonatomic, strong) NSMutableDictionary *selectedItems;
@end

@implementation AssetPickerViewController

- (id)init
{
    AssetGroupViewController *groupViewController = [[AssetGroupViewController alloc] init];
    
    if (self = [super initWithRootViewController:groupViewController])
    {
        _maximumNumberOfSelection      = 10;
        _minimumNumberOfSelection      = 0;
        _assetsFilter                  = [ALAssetsFilter allAssets];
        _showCancelButton              = YES;
        _showEmptyGroups               = NO;
        _selectionFilter               = [NSPredicate predicateWithValue:YES];
        _isFinishDismissViewController = YES;
        
        self.selectedItems = [[NSMutableDictionary alloc] init];
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        self.preferredContentSize = kPopoverContentSize;
#else
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
#endif
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Inner Methods
- (NSArray *)selectedAssets
{
    return self.selectedItems.allValues;
}

- (BOOL)isSelectedAsset:(ALAsset *)asset
{
    if (self.selectedItems && self.selectedItems.count > 0)
    {
//        for (NSString *key in self.selectedItems.allKeys)
//        {
//            if ([[[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString] isEqualToString:key])
//            {
//                return YES;
//            }
//        }
        // NSURL 实现了NSCoding协议 可以做主键
        return [self.selectedItems.allKeys containsObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
    }
    return NO;
}

- (BOOL)shouldSelectAsset:(ALAsset *)asset
{
    if (self.selectedItems && self.selectedItems.count > self.maximumNumberOfSelection)
    {
        if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)])
        {
            [self.pickerDelegate assetPickerControllerDidMaximum:self];
        }
    }
    
    BOOL selectable = [self.selectionFilter evaluateWithObject:asset];
    
    return (selectable && self.selectedItems.count < self.maximumNumberOfSelection);
}

- (void)didSelectAsset:(ALAsset *)asset
{
    // [self.selectedItems setObject:asset forKey:[[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString]];
    [self.selectedItems setObject:asset forKey:[asset valueForProperty:ALAssetPropertyAssetURL]];
    
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(assetPickerController:didSelectAsset:)])
        [self.pickerDelegate assetPickerController:self didSelectAsset:asset];
}

- (void)didDeselectAsset:(ALAsset *)asset
{
    // [self.selectedItems removeObjectForKey:[[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString]];
    [self.selectedItems removeObjectForKey:[asset valueForProperty:ALAssetPropertyAssetURL]];
    
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(assetPickerController:didDeselectAsset:)])
        [self.pickerDelegate assetPickerController:self didDeselectAsset:asset];
}

- (void)cancelPicking
{
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(assetPickerControllerDidCancel:)])
        [self.pickerDelegate assetPickerControllerDidCancel:self];
}

- (void)finishPicking
{
    if (self.selectedItems.count < self.minimumNumberOfSelection)
        if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)])
            [self.pickerDelegate assetPickerControllerDidMaximum:self];
    
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(assetPickerController:didFinishPickingAssets:)])
        [self.pickerDelegate assetPickerController:self didFinishPickingAssets:self.selectedItems.allValues];
}
@end
