//
//  AssetGroupViewController.h
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^LLAssetResponseBlock)(ALAsset *asset);
typedef void (^LLAssetFailureBlock)(NSError *error);
#pragma mark - AssetGroupViewController

@interface AssetGroupViewController : UITableViewController
+ (void)assetForALAssetURL:(NSURL *)assetURL completion:(LLAssetResponseBlock)completionBlock failure:(LLAssetFailureBlock)failureBlock;
@end
