//
//  UINavigationController+Custom.m
//  ennew
//
//  Created by jia on 15/7/16.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "UINavigationController+Custom.h"

#define kBottomLineGrayValue 176.0/255.0

static char shadowLayerKey;

@implementation UINavigationController (Custom)

- (void)setShadowLayer:(CALayer *)layer
{
    objc_setAssociatedObject(self, &shadowLayerKey, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)shadowLayer
{
    return objc_getAssociatedObject(self, &shadowLayerKey);
}

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
        
        // [self setShadowHidden:[self shouldHideShadowWhenColor:barColor]];
    }
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
- (BOOL)shouldHideShadowWhenColor:(UIColor *)bgColor
{
    return NO;
    
    CGFloat red, green, blue, alpha;
    [bgColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (red > kBottomLineGrayValue &&
        green > kBottomLineGrayValue &&
        blue > kBottomLineGrayValue)
    {
        return NO;
    }
    
    return YES;
}

- (void)setShadowHidden:(BOOL)hidden
{
    if (hidden)
    {
        if (!self.shadowLayer) return;
        [self.shadowLayer setHidden:YES];
    }
    else
    {
        if (!self.shadowLayer)
        {
            CGRect bottomLineFrame;
            bottomLineFrame.size.width = CGRectGetWidth(self.navigationBar.layer.bounds);
            bottomLineFrame.size.height = 0.5f;
            bottomLineFrame.origin.x = 0;
            bottomLineFrame.origin.y = CGRectGetHeight(self.navigationBar.layer.bounds) - CGRectGetHeight(bottomLineFrame);
            self.shadowLayer = [CALayer layer];
            [self.shadowLayer setFrame:bottomLineFrame];
            [self.shadowLayer setBackgroundColor:[UIColor colorWithRed:kBottomLineGrayValue green:kBottomLineGrayValue blue:kBottomLineGrayValue alpha:1.0f].CGColor];
            [self.navigationBar.layer addSublayer:self.shadowLayer];
        }
        
        [self.shadowLayer setHidden:NO];
    }
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
