//
//  LineBottomCategoryScrollView.h
//  LeSearchSDK
//
//  Created by JiaJunbo on 15/4/2.
//  Copyright (c) 2015年 Leso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorWithSize)
+ (UIImage *)imageWithColor:(UIColor *)uiColor andSize:(CGSize)size;
@end

@class LineBottomCategoryScrollView;

@protocol LineBottomCategoryScrollViewProtocol <NSObject>
@optional
- (NSString *)categoryTitleFromContentsWithIndex:(NSUInteger)index;

- (void)categoryView:(LineBottomCategoryScrollView *)categoryView
       selectedIndex:(NSUInteger)index
            oldIndex:(NSUInteger)oldIndex;
@end

@interface LineBottomCategoryScrollView : UIScrollView
@property (nonatomic, weak) id<LineBottomCategoryScrollViewProtocol> categoryDelegate;
// UI
@property (nonatomic, readwrite) float bottomLineHeight;
@property (nonatomic, strong) UIColor *bottomLineColor;

@property (nonatomic, readwrite) float spaceBetweenTwoItems; // 动态宽度 与itemWidth相排斥

@property (nonatomic, readwrite) float itemWidth; // 固定宽度 与spaceBetweenTwoItems相排斥
@property (nonatomic, readwrite) float itemBottomLineHeight;
@property (nonatomic, strong) UIColor *itemBottomLineSelectedColor;
@property (nonatomic, strong) UIColor *itemBottomLineNormalColor; // default: 透明
@property (nonatomic, strong) UIColor *itemBottomLineHighLightColor; // default: as SelectedColor
@property (nonatomic, strong) UIColor *itemTextSelectedColor;
@property (nonatomic, strong) UIColor *itemTextNormalColor;
@property (nonatomic, strong) UIColor *itemTextHighLightColor; // default: as SelectedColor
@property (nonatomic, strong) UIFont  *itemTextFont;

@property (nonatomic, getter=isUsingItemBackgroundColor) BOOL usingItemBackgroundColor;
@property (nonatomic, strong) UIColor *itemBackgroundSelectedColor;
@property (nonatomic, strong) UIColor *itemBackgroundNormalColor;   // default: clear


@property (nonatomic, getter=isUsingItemSeparaterLine) BOOL usingItemSeparaterLine; // default: NO
@property (nonatomic, readwrite) float itemSeparaterLineWidth;
@property (nonatomic, readwrite) float itemSeparaterLineHeight;
@property (nonatomic, strong) UIColor *itemSeparaterLineColor;

// Data
@property (nonatomic, strong) NSArray *categoryContents;
@property (nonatomic, strong) NSMutableArray *buttonItems;

- (void)reloadData;

- (NSInteger)currentSelectedIndex;

// 不是通过touch事件选中 而是通过函数调用迫使选中，最终还是会走选中之后的回调
- (void)forceToSelectIndex:(NSUInteger)index;
@end


@interface CategoryScrollViewItemButton : UIButton
@property (nonatomic, assign) BOOL usingTitle;

- (id)initWithFrame:(CGRect)frame bottomLineHeight:(float)bottomLineHeight;

- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)titleColor;
- (void)setTitleNMColor:(UIColor *)nmColor HLColor:(UIColor *)hlColor SELColor:(UIColor *)selColor;
- (void)setTitleFont:(UIFont *)font;
- (void)setImage:(UIImage *)image;
@end