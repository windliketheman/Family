//
//  AssetView.m
//  Family
//
//  Created by jia on 15/8/20.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "AssetView.h"
#import "AssetPickerDefine.h"

@interface NSDate (TimeInterval)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

@end

@implementation NSDate (TimeInterval)

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags =
    NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit |
    NSMonthCalendarUnit | NSYearCalendarUnit;
    
    return [calendar components:unitFlags fromDate:date1 toDate:date2 options:0];
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    NSInteger roundedSeconds = lround(timeInterval - (components.minute * 60) - (components.hour * 60 * 60));
    
    if (components.hour > 0)
    {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)roundedSeconds];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)roundedSeconds];
    }
}

@end


#pragma mark - AssetVideoTitleView

@implementation AssetVideoTitleView

- (void)drawRect:(CGRect)rect
{
    CGFloat colors [] =
    {
        0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.8,
        0.0, 0.0, 0.0, 1.0
    };
    
    CGFloat locations [] = {0.0, 0.75, 1.0};
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat height     = rect.size.height;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), height);
    CGPoint endPoint   = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    // 分割线
    // CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    
    CGSize titleSize = [self.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.f]}];//[self.text sizeWithFont:self.font];
    //    [self.textColor set];
    //    [self.text drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2 , (height - 12) / 2)
    //                   forWidth:kThumbnailLength
    //                   withFont:self.font
    //                   fontSize:12
    //              lineBreakMode:NSLineBreakByTruncatingTail
    //         baselineAdjustment:UIBaselineAdjustmentAlignCenters];
    //DLOG(@"self text ********%@",self.text);
    [self.text drawInRect:CGRectMake(rect.size.width - titleSize.width - 2, (height - 12) / 2, titleSize.width, titleSize.height) withAttributes:@{NSForegroundColorAttributeName:self.textColor, NSFontAttributeName:[UIFont systemFontOfSize:12.f]}];
    
    UIImage *videoIcon = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AssetPicker.Bundle/Images/AssetsPickerVideo@2x.png"]];
    
    [videoIcon drawAtPoint:CGPointMake(2, (height - videoIcon.size.height) / 2)];
    
}

@end

#pragma mark - TapAssetView

@interface TapAssetView ()

@property (nonatomic, strong) UIImageView *selectView;

@end

@implementation TapAssetView

static UIImage *checkedIcon;
static UIColor *selectedColor;
static UIColor *disabledColor;

+ (void)initialize
{
    checkedIcon = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"AssetPicker.Bundle/Images/%@@%dx.png", @"AssetsPickerChecked", (int)[[UIScreen mainScreen] scale]]]];
    selectedColor = [UIColor colorWithWhite:1 alpha:0.3];
    disabledColor = [UIColor colorWithWhite:1 alpha:0.9];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _selectView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_selectView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    self.selectView.frame = CGRectMake(frame.size.width-checkedIcon.size.width, frame.size.height-checkedIcon.size.height, checkedIcon.size.width, checkedIcon.size.height);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_disabled)
    {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(shouldTap)])
    {
        if (![_delegate shouldTap] && !_selected)
        {
            return;
        }
    }
    
    if ((_selected = !_selected))
    {
        self.backgroundColor = selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        [_selectView setImage:nil];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(touchSelect:)])
    {
        [_delegate touchSelect:_selected];
    }
}

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;
    if (_disabled)
    {
        self.backgroundColor = disabledColor;
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (_disabled)
    {
        self.backgroundColor = disabledColor;
        [_selectView setImage:nil];
        return;
    }
    
    _selected = selected;
    if (_selected)
    {
        self.backgroundColor = selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        [_selectView setImage:nil];
    }
}

@end

#pragma mark - AssetView

@interface AssetView () <TapAssetViewDelegate>

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AssetVideoTitleView *videoTitle;
@property (nonatomic, strong) TapAssetView *tapAssetView;

@end

@implementation AssetView

static UIFont *titleFont = nil;

static CGFloat titleHeight;
static UIColor *titleColor;

+ (void)initialize
{
    titleFont   = [UIFont systemFontOfSize:12];
    titleHeight = 20.0f;
    titleColor  = [UIColor whiteColor];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        
        _videoTitle = [[AssetVideoTitleView alloc] initWithFrame:CGRectZero];
        _videoTitle.hidden = YES;
        _videoTitle.font = titleFont;
        _videoTitle.textColor = titleColor;
        _videoTitle.textAlignment = NSTextAlignmentRight;
        _videoTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_videoTitle];
        
        _tapAssetView = [[TapAssetView alloc] initWithFrame:CGRectZero];
        _tapAssetView.delegate = self;
        [self addSubview:_tapAssetView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.videoTitle.frame = CGRectMake(0, frame.size.height-20, frame.size.width, titleHeight);
    self.tapAssetView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced
{
    self.asset = asset;
    
    [_imageView setImage:[UIImage imageWithCGImage:asset.thumbnail]];
    
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        _videoTitle.hidden = NO;
        _videoTitle.text = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    }
    else
    {
        _videoTitle.hidden = YES;
    }
    
    _tapAssetView.disabled = ![selectionFilter evaluateWithObject:asset];
    
    _tapAssetView.selected = isSeleced;
}

#pragma mark - TapAssetView Delegate

- (BOOL)shouldTap
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldSelectAsset:)])
    {
        return [_delegate shouldSelectAsset:_asset];
    }
    return YES;
}

- (void)touchSelect:(BOOL)select
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapSelectHandle:asset:)])
    {
        [_delegate tapSelectHandle:select asset:_asset];
    }
}

@end
