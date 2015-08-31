//
//  UINavigationController+Custom.m
//  ennew
//
//  Created by jia on 15/7/16.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "UINavigationController+Custom.h"

#define kBottomLineGrayValue 176.0/255.0

static UIImage *defaultShadowImage = nil;

@implementation UINavigationController (Custom)

- (void)setNavigationBarColor:(UIColor *)barColor
{
    if (self.navigationBar.translucent)
    {
        // barTintColor 导航栏背景色
        [self.navigationBar setBarTintColor:barColor];
    }
    else
    {
        [self.navigationBar setBackgroundImage:[self imageWithColor:barColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    }
    
    if (!defaultShadowImage) defaultShadowImage = self.navigationBar.shadowImage;
    
    BOOL shouldShow = [self shouldShowShadowImageUnderColor:barColor];
    self.navigationBar.shadowImage = shouldShow ? defaultShadowImage : [[UIImage alloc] init];
}

- (void)setNavigationBarTitleColor:(UIColor *)textColor
{
    // 导航栏文字颜色
    NSString *textColorAttribute = ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0f) ? NSForegroundColorAttributeName : UITextAttributeTextColor;
    [self.navigationBar setTitleTextAttributes:@{textColorAttribute : textColor}];
    
    // tintColor 设置导航栏左右按钮颜色
    [self.navigationBar setTintColor:textColor];
}

#pragma mark - Bottom Line
- (BOOL)shouldShowShadowImageUnderColor:(UIColor *)bgColor
{
    CGFloat red, green, blue, alpha;
    [bgColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (red > kBottomLineGrayValue &&
        green > kBottomLineGrayValue &&
        blue > kBottomLineGrayValue)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - Tools Methods
- (UIImage *)imageWithColor:(UIColor *)uiColor size:(CGSize)size
{
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size = size;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [uiColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
