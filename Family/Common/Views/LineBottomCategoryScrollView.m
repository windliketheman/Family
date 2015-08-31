//
//  LineBottomCategoryScrollView.m
//  LeSearchSDK
//
//  Created by JiaJunbo on 15/4/2.
//  Copyright (c) 2015年 Leso. All rights reserved.
//

#import "LineBottomCategoryScrollView.h"

#define kButtonBaseTag 100


@implementation UIImage (ColorWithSize)

+ (UIImage *)imageWithColor:(UIColor *)uiColor andSize:(CGSize)size
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


@interface LineBottomCategoryScrollView ()
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) NSMutableArray *shuxianItems;

@property(nonatomic, strong) CategoryScrollViewItemButton *currentSelectedBtn;
@end

@implementation LineBottomCategoryScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _buttonItems = [[NSMutableArray alloc] init];
        _shuxianItems = [[NSMutableArray alloc] init];
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _usingItemSeparaterLine = NO;
        
        _spaceBetweenTwoItems = 0.0f;
    }
    
    return self;
}

- (void)dealloc
{
    self.categoryContents = nil;
    
    [self.buttonItems removeAllObjects];
    self.buttonItems = nil;
    
    [self.shuxianItems removeAllObjects];
    self.shuxianItems = nil;
}

- (void)clear
{
    self.currentSelectedBtn = nil;
    
    // 移除按钮
    for (UIView *view in self.subviews)
    {
        if ([self.buttonItems containsObject:view])
        {
            [view removeFromSuperview];
            [self.buttonItems removeObject:view];
        }
        else if (self.usingItemSeparaterLine && [self.shuxianItems containsObject:view])
        {
            [view removeFromSuperview];
            [self.shuxianItems removeObject:view];
        }
    }
}

- (void)reloadData
{
    [self clear];
    
    float shuxianMaxHeight = CGRectGetHeight(self.bounds) - self.bottomLineHeight - self.itemBottomLineHeight;
    if (self.itemSeparaterLineHeight > shuxianMaxHeight)
    {
        self.itemSeparaterLineHeight = shuxianMaxHeight;
    }
    
    [self addBottomLine];
    
    [self addButtonItems];
    
    // 关于 item 之间的竖线
    [self addShuxianItems];
}

- (void)addBottomLine
{
    if (self.bottomLineHeight > 0.0f)
    {
        if (!self.bottomLineView)
        {
            _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
            [_bottomLineView setBackgroundColor:self.bottomLineColor];
            [self addSubview:_bottomLineView];
        }
        
        [self bringSubviewToFront:self.bottomLineView];
    }
}

- (void)addButtonItems
{
    for (int i = 0; i < self.categoryContents.count; ++i)
    {
        NSString *itemTitle = @"";
        if (self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(categoryTitleFromContentsWithIndex:)])
        {
            itemTitle = [self.categoryDelegate categoryTitleFromContentsWithIndex:i];
        }
        else
        {
            itemTitle = self.categoryContents[i];
        }
        
        float currentItemWidth = self.spaceBetweenTwoItems > 0.0f ? [self itemWidthWhenFixItemSpaceWidth:itemTitle] : self.itemWidth;
        
        CGSize imageSize = CGSizeMake(currentItemWidth, self.itemBottomLineHeight);
        UIColor *buttonItemBottomLineNormalColor = self.itemBottomLineNormalColor ? self.itemBottomLineNormalColor : [UIColor clearColor];
        UIColor *buttonItemBottomLineHLColor = self.itemBottomLineHighLightColor ? self.itemBottomLineHighLightColor : self.itemBottomLineSelectedColor;
        UIImage *nmImage = [UIImage imageWithColor:buttonItemBottomLineNormalColor andSize:imageSize];
        UIImage *hlImage = [UIImage imageWithColor:buttonItemBottomLineHLColor andSize:imageSize];
        UIImage *selImage = [UIImage imageWithColor:self.itemBottomLineSelectedColor andSize:imageSize];
        
        CGRect btnRect = CGRectZero;
        btnRect.size = CGSizeMake(currentItemWidth, CGRectGetHeight(self.frame));
        
        
        UIColor *buttonItemTextHLColor = self.itemTextHighLightColor ? self.itemTextHighLightColor : self.itemTextSelectedColor;
        
        CategoryScrollViewItemButton *btn = [[CategoryScrollViewItemButton alloc] initWithFrame:btnRect bottomLineHeight:imageSize.height];
        [btn setTitle:itemTitle];
        [btn setTitleNMColor:self.itemTextNormalColor HLColor:buttonItemTextHLColor SELColor:self.itemTextSelectedColor];
        [btn setTitleFont:self.itemTextFont];
        [btn setImage:nmImage forState:UIControlStateNormal];
        [btn setImage:hlImage forState:UIControlStateHighlighted];
        [btn setImage:selImage forState:UIControlStateSelected];
        
        if (self.isUsingItemBackgroundColor)
        {
            if (self.itemBackgroundNormalColor)
            {
                UIImage *normalBG = [UIImage imageWithColor:self.itemBackgroundNormalColor andSize:btn.frame.size];
                [btn setBackgroundImage:normalBG forState:UIControlStateNormal];
            }
            
            if (self.itemBackgroundSelectedColor)
            {
                UIImage *selectedBG = [UIImage imageWithColor:self.itemBackgroundSelectedColor andSize:btn.frame.size];
                [btn setBackgroundImage:selectedBG forState:UIControlStateSelected];
            }
        }
        
        [self.buttonItems addObject:btn];
        [self addSubview:btn];
        
        [btn setTag:(kButtonBaseTag + i)];
        [btn addTarget:self action:@selector(itemButtonSelected:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        if (0 == i)
        {
            btn.selected = YES;
            btn.userInteractionEnabled = NO;
            self.currentSelectedBtn = btn;
        }
        else
        {
            btn.selected = NO;
        }
    }
}

- (void)addShuxianItems
{
    if (self.isUsingItemSeparaterLine && self.categoryContents.count >= 2)
    {
        CGRect shuxianRect = CGRectZero;
        shuxianRect.size.width = self.itemSeparaterLineWidth;
        shuxianRect.size.height = self.itemSeparaterLineHeight;
        shuxianRect.origin.y = (CGRectGetHeight(self.frame) - self.itemBottomLineHeight - CGRectGetHeight(shuxianRect)) / 2;
        if (shuxianRect.origin.y < 0.0f) shuxianRect.origin.y = 0.0f;
        
        // 先加 具体frame在layout里调整
        for (int i = 0; i <= self.categoryContents.count - 2; ++i)
        {
            UIView *shuxianView = [[UIView alloc] initWithFrame:shuxianRect];
            [shuxianView setBackgroundColor:self.itemSeparaterLineColor];
            [self addSubview:shuxianView];
            
            [self.shuxianItems addObject:shuxianView];
        }
    }
}

- (float)itemWidthWhenFixItemSpaceWidth:(NSString *)itemTitle
{
    float fontSize = self.itemTextFont.pointSize;
    return (itemTitle.length * fontSize) + self.spaceBetweenTwoItems * 2;
}

- (NSInteger)currentSelectedIndex
{
    if (self.currentSelectedBtn)
    {
        return [self indexFromBtn:self.currentSelectedBtn];
    }
    else
    {
        return 0;
    }
}

- (NSInteger)indexFromBtn:(UIButton *)btn
{
    return (btn.tag - kButtonBaseTag);
}

- (void)itemButtonSelected:(CategoryScrollViewItemButton *)newSelectedBtn withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.tapCount > 1)
    {
        return;
    }
    
    // 当前选中的不能点
    newSelectedBtn.userInteractionEnabled = NO;
    
    NSInteger lastTimeIndex = [self currentSelectedIndex];
    
    // 现在和上一次不是同一按钮
    if ([self indexFromBtn:newSelectedBtn] != lastTimeIndex)
    {
        for (CategoryScrollViewItemButton *btn in self.buttonItems)
        {
            btn.selected = (btn == newSelectedBtn);
            btn.userInteractionEnabled = !btn.selected;
            
            if (btn.selected)
            {
                self.currentSelectedBtn = btn;
            }
        }
        
        [self scrollButtonToViewCenter:newSelectedBtn];
    }
    
    if (self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(categoryView:selectedIndex:oldIndex:)])
    {
        [self.categoryDelegate categoryView:self selectedIndex:(newSelectedBtn.tag - kButtonBaseTag) oldIndex:event ? lastTimeIndex : NSNotFound];
    }
}

- (void)forceToSelectIndex:(NSUInteger)index
{
    if (index >= [self.buttonItems count])
    {
        return;
    }
    
    CategoryScrollViewItemButton *targetButton = self.buttonItems[index];
    [self itemButtonSelected:targetButton withEvent:nil];
}

- (void)scrollButtonToViewCenter:(CategoryScrollViewItemButton *)btn
{
    if (self.contentSize.width < self.bounds.size.width)
    {
        return;
    }
    
    float scrollMinX = 0;
    float scrollMaxX = self.contentSize.width - CGRectGetWidth(self.frame);
    
    
    CGPoint buttonCenter = btn.center;
    float viewCenterX = self.contentOffset.x + CGRectGetWidth(self.frame) / 2;
    float xOffset = buttonCenter.x - viewCenterX;
    
    CGPoint shiftToPoint = self.contentOffset;
    shiftToPoint.x += xOffset;
    
    if (shiftToPoint.x < scrollMinX)
    {
        shiftToPoint.x = 0;
    }
    else if (shiftToPoint.x > scrollMaxX)
    {
        shiftToPoint.x = scrollMaxX;
    }
    else
    {
        // do nothing
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.contentOffset = shiftToPoint;
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect btnRect;
    btnRect.origin = CGPointZero;
    btnRect.size.height = CGRectGetHeight(self.frame);
    
    CGRect shuxianRect;
    
    for (int i = 0; i < self.buttonItems.count; ++i)
    {
        CategoryScrollViewItemButton *btn = self.buttonItems[i];
        
        btnRect.size.width = CGRectGetWidth(btn.frame);
        [btn setFrame:btnRect];
        
        // 下一个button的x
        if (i + 1 < self.buttonItems.count)
        {
            btnRect.origin.x += btnRect.size.width;
            
            // 竖线
            if (self.usingItemSeparaterLine && i < self.shuxianItems.count)
            {
                shuxianRect = ((UIView *)self.shuxianItems[i]).frame;
                shuxianRect.origin.x = btnRect.origin.x - 0.5f;
                
                [((UIView *)self.shuxianItems[i]) setFrame:shuxianRect];
            }
        }
    }
    
    // 本身内容宽度
    self.contentSize = CGSizeMake(CGRectGetMaxX(btnRect), CGRectGetHeight(self.frame));
    
    CGRect bottomLineFrame;
    bottomLineFrame.size.width = MAX(self.contentSize.width, self.bounds.size.width);
    bottomLineFrame.size.height = self.bottomLineHeight;
    bottomLineFrame.origin.x = 0;
    bottomLineFrame.origin.y = CGRectGetHeight(self.frame) - bottomLineFrame.size.height;
    self.bottomLineView.frame = bottomLineFrame;
}

@end


@interface CategoryScrollViewItemButton ()
{
    NSString *_initTitle;
}
@end

@implementation CategoryScrollViewItemButton

- (id)initWithFrame:(CGRect)frame bottomLineHeight:(float)bottomLineHeight
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.exclusiveTouch = YES;
        
        UIColor *titleColor = [UIColor blueColor]; // RGBCOLOR(187, 158, 195);
        
        [self setTitleColor:titleColor];
        
        CGSize imageSize = CGSizeMake(CGRectGetWidth(self.frame), bottomLineHeight);
        
        // UIEdgeInsetsMake(top, left, bottom, right) 四个参数的意思，是你设置的这个title内容离这个but每个边的距离是多少
        float imageLeft = (frame.size.width - imageSize.width) / 2;
        [self setImageEdgeInsets:UIEdgeInsetsMake(CGRectGetHeight(frame) - imageSize.height, imageLeft, 0, imageLeft)];
        
        // 图片 title上下布局 图按照逻辑设置edge，文字重点是left 为－button width，right 0
        // 图片 title 左右布局 要设置contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft，这样才能让不同长度的title都向左对齐，不然文字以width居中对齐
        // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, bottomLineHeight, 0)]; // 文字处于 除去bottom line区域上下居中
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, 0)]; // 文字处于 button高度上下居中 比上边注释掉的稍稍偏下
        // self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self setTitleFont:[UIFont systemFontOfSize:14]];
    }
    
    return self;
}

- (void)setUsingTitle:(BOOL)userUsing
{
    _usingTitle = userUsing;
    
    if (!_usingTitle)
    {
        [self setTitle:@""];
    }
    else
    {
        [self setTitle:_initTitle];
    }
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
}

- (void)setInitTitle:(NSString *)initTitle
{
    _initTitle = initTitle;
    
    [self setTitle:_initTitle];
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
}

- (void)setTitleNMColor:(UIColor *)nmColor HLColor:(UIColor *)hlColor SELColor:(UIColor *)selColor
{
    [self setTitleColor:nmColor forState:UIControlStateNormal];
    [self setTitleColor:hlColor forState:UIControlStateHighlighted];
    [self setTitleColor:selColor forState:UIControlStateSelected];
}

- (void)setTitleFont:(UIFont *)font
{
    [self.titleLabel setFont:font];
}

@end
