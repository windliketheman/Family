//
//  AssetTableViewCell.m
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "AssetTableViewCell.h"
#import "AssetView.h"
#import "AssetPickerDefine.h"

#pragma mark - AssetTableViewCell

@interface AssetTableViewCell () <AssetViewDelegate>

@end

@class AssetViewController;

@implementation AssetTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (BOOL)isSelectedAsset:(ALAsset *)asset
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(isSelectedAsset:)])
    {
        return [self.delegate isSelectedAsset:asset];
    }
    return NO;
}

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter itemSpacing:(float)itemSpacing columns:(NSUInteger)columns rowX:(float)rowX
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.thumbnailSize.width, self.thumbnailSize.height);
    
    if (self.contentView.subviews.count < assets.count)
    {
        for (int i = 0; i < assets.count; i++)
        {
            rect.origin.x = rowX + (self.thumbnailSize.width + itemSpacing)*(i);
            rect.origin.y = itemSpacing - 1;
            
            if (i > ((NSInteger)self.contentView.subviews.count - 1))
            {
                AssetView *assetView = [[AssetView alloc] initWithFrame:rect];
                [assetView bind:assets[i] selectionFilter:selectionFilter isSeleced:[self isSelectedAsset:assets[i]]];
                assetView.delegate = self;
                [self.contentView addSubview:assetView];
            }
            else
            {
                ((AssetView *)self.contentView.subviews[i]).frame = rect;
                [(AssetView *)self.contentView.subviews[i] bind:assets[i] selectionFilter:selectionFilter isSeleced:[self isSelectedAsset:assets[i]]];
            }
        }
    }
    else
    {
        for (unsigned long i = self.contentView.subviews.count; i > 0; i--)
        {
            NSUInteger index = i - 1;
            
            if (i > assets.count)
            {
                [((AssetView *)self.contentView.subviews[index]) removeFromSuperview];
            }
            else
            {
                rect.origin.x = rowX + (self.thumbnailSize.width + itemSpacing)*(index);
                rect.origin.y = itemSpacing - 1;
                
                ((AssetView *)self.contentView.subviews[index]).frame = rect;
                [(AssetView *)self.contentView.subviews[index] bind:assets[index] selectionFilter:selectionFilter isSeleced:[self isSelectedAsset:assets[index]]];
            }
        }
    }
}

#pragma mark - AssetView Delegate

- (BOOL)shouldSelectAsset:(ALAsset *)asset
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldSelectAsset:)])
    {
        return [_delegate shouldSelectAsset:asset];
    }
    return YES;
}

- (void)tapSelectHandle:(BOOL)select asset:(ALAsset *)asset
{
    if (select)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectAsset:)])
        {
            [_delegate didSelectAsset:asset];
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(didDeselectAsset:)])
        {
            [_delegate didDeselectAsset:asset];
        }
    }
}

@end
