//
//  UIImage+Extension.h
//  乐拍
//
//  Created by junbo jia on 14-7-24.
//  Copyright (c) 2014年 Letv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)uiColor size:(CGSize)size;

@end


@interface UIImage (CacheMode)

+ (UIImage *)imageUsingCacheMode:(NSString *)imageName;

+ (UIImage *)imageNotUsingCacheMode:(NSString *)imageName;

// for bar, using our image
+ (UIImage *)originalImageNamed:(NSString *)imageName;
- (UIImage *)originalImage;
@end


@interface UIImage (Tint)

+ (UIImage *)imageNamed:(NSString *)name withTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

@end


@interface UIImage (Thumbnails)

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize alignmentCenter:(BOOL)isCenter;

// 等比缩放 来匹配尺寸 可能不满
- (UIImage *)scaleToFit:(CGSize)targetSize;

// 等比缩放 来填充尺寸 超出的自动裁剪
- (UIImage *)scaleToFill:(CGSize)targetSize;

@end

@interface UIImage (MakeImage)

// 2张图合成1张
+ (UIImage *)addImage:(UIImage *)upperImage toImage:(UIImage *)baseImage;
+ (UIImage *)addImage:(UIImage *)upperImage toImage:(UIImage *)baseImage atCenter:(BOOL)atCenter;

- (UIImage *)addImage:(UIImage *)upperImage;
- (UIImage *)addImage:(UIImage *)upperImage atCenter:(BOOL)atCenter;

@end

@interface UIImage (Reflection)

// 投影
- (UIImage *)addReflection:(CGFloat)reflectionScale;

@end