//
//  SettingTableViewCell.m
//  Family
//
//  Created by jia on 15/9/23.
//  Copyright © 2015年 jia. All rights reserved.
//

#import "SettingTableViewCell.h"

#define kCellBackgroundColor          [UIColor whiteColor]
#define kCellTextLabelTextColor       [UIColor redColor]
#define kCellSelectedBackgroundColor  [UIColor grayColor]

#define kSegmentViewColor             [UIColor blueColor]
#define kSwitchViewColor              [UIColor greenColor]
#define kIndicatorTextColor           [UIColor yellowColor]

#define kThemeChangedNotification @""

@implementation SettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = kCellBackgroundColor;
        [self.textLabel setTextColor:kCellTextLabelTextColor];
        [self.selectedBackgroundView setBackgroundColor:kCellSelectedBackgroundColor];
        
        [self setSegmentViewColor:kSegmentViewColor];
        [self setSwitchViewColor:kSwitchViewColor];
        [self setIndicatorTextColor:kIndicatorTextColor];
        
        [self addThemeChangedNotificationObserver];
    }
    return self;
}

- (void)dealloc
{
    [self removeThemeChangedNotificationObserver];
}

#pragma mark - Theme

- (void)addThemeChangedNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChangedNotification object:nil];
}

- (void)removeThemeChangedNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotification object:nil];
}

- (void)themeChanged
{
    [self setSegmentViewColor:kSegmentViewColor];
    [self setSwitchViewColor:kSwitchViewColor];
    [self setIndicatorTextColor:kIndicatorTextColor];
}

@end
