//
//  BaseNavigationBar.m
//  Lepai
//
//  Created by junbo jia on 14/11/9.
//  Copyright (c) 2014年 jia. All rights reserved.
//

#import "BaseNavigationBar.h"

@interface BaseNavigationBar ()
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation BaseNavigationBar

static CGFloat const kDefaultColorLayerOpacity = 0.4f;
static CGFloat const kSpaceToCoverStatusBars = 20.0f;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CALayer *colorLayer = [CALayer layer];
        colorLayer.opacity = kDefaultColorLayerOpacity;
        colorLayer.hidden = YES;
        [self.layer addSublayer:colorLayer];
        
        self.colorLayer = colorLayer;
    }
    return self;
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    if (barTintColor)
    {
        CGFloat red, green, blue, alpha;
        [barTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
        
        UIColor *calibratedColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.66];
        [super setBarTintColor:calibratedColor];
        
        CGFloat opacity = kDefaultColorLayerOpacity;
        
        CGFloat minVal = MIN(MIN(red, green), blue);
        
        if ([self convertValue:minVal withOpacity:opacity] < 0)
        {
            opacity = [self minOpacityForValue:minVal];
        }
        
        self.colorLayer.opacity = opacity;
        
        red = [self convertValue:red withOpacity:opacity];
        green = [self convertValue:green withOpacity:opacity];
        blue = [self convertValue:blue withOpacity:opacity];
        
        red = MAX(MIN(1.0, red), 0);
        green = MAX(MIN(1.0, green), 0);
        blue = MAX(MIN(1.0, blue), 0);
        
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha].CGColor;
    }
    else
    {
        [super setBarTintColor:nil];
        
        self.colorLayer.opacity = 0.0f;
    }
}

- (CGFloat)convertValue:(CGFloat)value withOpacity:(CGFloat)opacity
{
    return 0.4 * value / opacity + 0.6 * value - 0.4 / opacity + 0.4;
}

- (CGFloat)minOpacityForValue:(CGFloat)value
{
    return (0.4 - 0.4 * value) / (0.4 + 0.6 * value);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.colorLayer)
    {
        self.colorLayer.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);
        
        [self.layer insertSublayer:self.colorLayer atIndex:1];
    }
}

- (void)usingSystemTranslucent:(BOOL)systemTranslucent
{
    self.colorLayer.hidden = systemTranslucent;
}

@end
