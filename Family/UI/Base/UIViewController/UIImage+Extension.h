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

#define kTextRssTextKey       @"TextRssText"
#define kTextRssFontKey       @"TextRssFont"
#define kTextRssColorKey      @"TextRssColor"
#define kTextRssParagraphKey  @"TextRssParagraph"

// 2张图合成1张
@interface UIImage (MakeImage)
// place upper image in origin (0, 0)
+ (UIImage *)addImage:(UIImage *)upperImage toImage:(UIImage *)baseImage;
// place upper image in origin center ? center : (0, 0)
+ (UIImage *)addImage:(UIImage *)upperImage toImage:(UIImage *)baseImage inCenter:(BOOL)center;
// place upper image in rect
+ (UIImage *)addImage:(UIImage *)upperImage toImage:(UIImage *)baseImage inRect:(CGRect)rect;
// place image, text in rects
+ (UIImage *)addResources:(NSArray *)rss inRects:(NSArray *)rects toImage:(UIImage *)baseImage;
@end

@interface UIImage (Reflection)

// 投影
- (UIImage *)addReflection:(CGFloat)reflectionScale;

@end