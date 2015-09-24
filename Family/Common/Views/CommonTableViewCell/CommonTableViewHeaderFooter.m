//
//  CommonTableViewHeaderFooter.m
//  FileBox
//
//  Created by jia on 15/9/23.
//  Copyright © 2015年 OrangeTeam. All rights reserved.
//

#import "CommonTableViewHeaderFooter.h"

#define IsIphone6Plus (CGRectGetWidth([[UIScreen mainScreen] bounds]) >= 414)

#define kHeaderFooterDefaultHeight    18
#define kHeaderFooterTextingHeight    (IsIphone6Plus ? kHeaderFooterDefaultHeight + 20 : kHeaderFooterDefaultHeight + 14)


@interface CommonTableViewHeaderFooter ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CommonTableViewHeaderFooter

+ (float)defaultHeight
{
    return -1; // tableView.sectionFooterHeight, real value is kHeaderFooterDefaultHeight
}

+ (float)textingHeight
{
    return kHeaderFooterTextingHeight;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:13]];
        [titleLabel setTextColor:[UIColor colorWithRed:109/255.0f green:109/255.0f blue:114/255.0f alpha:1.0f]];
        [self addSubview:titleLabel];
        
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textLabelRect = CGRectZero;
    textLabelRect.origin.x = IsIphone6Plus ? 20.0f : 15.0f; // plus: 20
    textLabelRect.size.width = CGRectGetWidth(self.bounds) - textLabelRect.origin.x * 2;
    textLabelRect.size.height = 15;
    textLabelRect.origin.y = (CGRectGetHeight(self.bounds) - textLabelRect.size.height) / 2;
    [self.titleLabel setFrame:textLabelRect];
}

- (void)setTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}

@end
