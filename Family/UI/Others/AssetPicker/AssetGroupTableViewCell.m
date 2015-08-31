//
//  AssetGroupTableViewCell.m
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "AssetGroupTableViewCell.h"
#import "AssetPickerDefine.h"

#pragma mark - AssetGroupTableViewCell

@interface AssetGroupTableViewCell ()

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end

@implementation AssetGroupTableViewCell


- (void)bind:(ALAssetsGroup *)assetsGroup
{
    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / kGroupThumbnailLength;
    
    self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.textLabel.font         = [UIFont systemFontOfSize:17];
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    self.detailTextLabel.font   = [UIFont systemFontOfSize:12];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}

+ (CGFloat)cellHeight
{
    return kGroupThumbnailLength + 12;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x = CGRectGetHeight(self.bounds) - CGRectGetHeight(imageViewFrame);
    imageViewFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(imageViewFrame)) / 2 + 1;
    self.imageView.frame = imageViewFrame;
}

- (NSString *)accessibilityLabel
{
    NSString *label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    return [label stringByAppendingFormat:NSLocalizedString(@"%ld 张照片", nil), (long)[self.assetsGroup numberOfAssets]];
}

@end
