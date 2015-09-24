//
//  CommonTableViewCell.m
//  FileBox
//
//  Created by jia on 15/9/23.
//  Copyright © 2015年 OrangeTeam. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "NotificationNameDefine.h"

#define kSystemGreenSwitchColor RGBCOLOR(75, 216, 99)

#define kSegmentColor           kThemeColor
#define kSwitchColor            kSettingSwitchColor
#define kArrowTextColor         kCellArrowTextColor

// 5s 6 is 15, 6plus is 20
#define kControlLeftSpace      CGRectGetMinX(self.textLabel.frame)
#define kArrowWidth            8
#define kArrowTextToArrow      (kControlLeftSpace - 2)

@interface CommonTableViewCell ()
{
    //
}
@property (nonatomic, strong) UIColor *segmentedViewColor;
@end

@implementation CommonTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:15]];
        
        CGRect selectViewRect = CGRectZero;
        UIView *selectionView = [[UIView alloc] initWithFrame:selectViewRect];
        self.selectedBackgroundView = selectionView;
        
        [self setupSubviews];
        
        self.segmentedViewColor = [UIColor blueColor];
        self.segmentViewDataSource = @[@{@"text": NSLocalizedString(@"Name1", nil), @"icon": @""}, @{@"text": NSLocalizedString(@"Name2", nil), @"icon": @""}];
    }
    return self;
}

- (void)setSegmentViewDataSource:(NSArray *)segmentViewDataSource
{
    _segmentViewDataSource = segmentViewDataSource;
    
    if (self.segmentView)
    {
        [self.segmentView removeFromSuperview];
    }
    
    self.segmentView = [self createSegmentViewWithDataSource:self.segmentViewDataSource];
    [self.contentView addSubview:self.segmentView];
}

- (void)setupSubviews
{
    _arrowTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_arrowTextLabel setTextAlignment:NSTextAlignmentRight];
    [_arrowTextLabel setFont:[UIFont systemFontOfSize:15]];
    [_arrowTextLabel setTextColor:[UIColor darkGrayColor]];
    // [_arrowTextLabel setBackgroundColor:[UIColor redColor]];
    
    [self.contentView addSubview:_arrowTextLabel];
    
    _switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_switchView setOnTintColor:[UIColor greenColor]];
    [_switchView setOn:NO animated:NO];
    [_switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:_switchView];
}

- (PPiFlatSegmentedControl *)createSegmentViewWithDataSource:(NSArray *)dataSource
{
    CGRect segmentRect = CGRectZero;
    segmentRect.size.width = 106;
    segmentRect.size.height = 29;
    PPiFlatSegmentedControl *segmentedControl = [[PPiFlatSegmentedControl alloc] initWithFrame:segmentRect
                                                            items:dataSource
                                                     iconPosition:IconPositionRight
                                                andSelectionBlock:^(NSUInteger segmentIndex) {
                                                    
                                                    // NSLog(@"old selection method");
                                                }];
    
    segmentedControl.borderWidth = 0.5;
    [self customSegmentedView:segmentedControl selectedColor:self.segmentedViewColor];
    
    return segmentedControl;
}

- (CGFloat)cellWidth
{
    UIDeviceOrientation orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    if (SystemVersion >= 8.0)
    {
        return [[UIScreen mainScreen] bounds].size.width;
    }
    else
    {
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            return [[UIScreen mainScreen] bounds].size.height;
        }
        else
        {
            return [[UIScreen mainScreen] bounds].size.width;
        }
    }
}

+ (float)cellHeight
{
    return 45.0f;
}

- (CGRect)cellFrame
{
    CGRect cellFrame = self.frame;
    cellFrame.size.height = [[self class] cellHeight];
    
    return cellFrame;
}

- (void)setAccessoryStyle:(TableViewCellAccessoryStyle)style
{
    _accessoryStyle = style;
    
    switch (style)
    {
        case TableViewCellAccessoryIndicator:
        {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self showView:nil];
            break;
        }
        case TableViewCellAccessoryTextIndicator:
        {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self showView:self.arrowTextLabel];
            break;
        }
        case TableViewCellAccessoryDetailIndicator:
        {
            self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [self showView:nil];
            break;
        }
        case TableViewCellAccessoryDetailButton:
        {
            self.accessoryType = UITableViewCellAccessoryDetailButton;
            [self showView:nil];
            break;
        }
        case TableViewCellAccessoryCheckmark:
        {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
            [self showView:nil];
            break;
        }
        case TableViewCellAccessorySwitch:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionEnable = NO;
            [self showView:self.switchView];
            break;
        }
        case TableViewCellAccessorySegment:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionEnable = NO;
            
            [self showView:self.segmentView];
            break;
        }
        default:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            [self showView:nil];
            break;
        }
    }
}

- (void)setSelectionEnable:(BOOL)selectionEnable
{
    _selectionEnable = selectionEnable;
    self.selectionStyle = selectionEnable ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
}

- (void)setSegmentViewColor:(UIColor *)segmentSelectedColor
{
    _segmentedViewColor = segmentSelectedColor;
    
    if (self.segmentView)
    {
        [self customSegmentedView:self.segmentView selectedColor:_segmentedViewColor];
    }
}

- (void)customSegmentedView:(PPiFlatSegmentedControl *)segmentedView selectedColor:(UIColor *)segmentSelectedColor
{
    segmentedView.color = [UIColor whiteColor];
    segmentedView.borderColor = segmentSelectedColor;
    segmentedView.selectedColor = segmentSelectedColor;
    segmentedView.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                    NSForegroundColorAttributeName:segmentSelectedColor};
    segmentedView.selectedTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                            NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)setSwitchViewColor:(UIColor *)switchColor
{
    [self.switchView setOnTintColor:switchColor];
}

- (void)setIndicatorTextColor:(UIColor *)indicatorTextColor
{
    [self.arrowTextLabel setTextColor:indicatorTextColor];
}

// hide one
- (void)hideView:(UIView *)view
{
    if (view)
    {
        view.hidden = YES;
    }
}

// show one, hide others
- (void)showView:(UIView *)view
{
    if (self.switchView)
    {
        self.switchView.hidden = YES;
    }
    
    if (self.segmentView)
    {
        self.segmentView.hidden = YES;
    }
    
    if (self.arrowTextLabel)
    {
        self.arrowTextLabel.hidden = YES;
    }
    
    if (view)
    {
        view.hidden = NO;
    }
}

//- (void)setFrame:(CGRect)frame
//{
//    frame.size.width = CGRectGetWidth(self.window.bounds);
//    [super setFrame:frame];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGRect backgroundViewBounds = self.backgroundView.bounds;
    CGRect contentViewBounds = self.contentView.bounds;
    self.selectedBackgroundView.frame = self.bounds;
    
    if (self.switchView)
    {
        CGRect controlRect = self.switchView.frame;
        controlRect.origin.x = CGRectGetWidth(self.bounds) - controlRect.size.width - kControlLeftSpace;
        controlRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(controlRect)) / 2;
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
        {
            controlRect.origin.x -= 15;
        }
        
        self.switchView.frame = controlRect;
    }
    
    if (self.segmentView)
    {
        CGRect controlRect = self.segmentView.frame;
        controlRect.origin.x = CGRectGetWidth(self.bounds) - controlRect.size.width - kControlLeftSpace;
        controlRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(controlRect)) / 2;
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
        {
            controlRect.origin.x -= 15;
        }
        
        self.segmentView.frame = controlRect;
    }
    
    if (self.arrowTextLabel)
    {
        CGRect controlRect;
        controlRect.size.width = 120;
        controlRect.size.height = 31;
        controlRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(controlRect)) / 2;
        controlRect.origin.x = CGRectGetWidth(self.bounds) - (controlRect.size.width + kArrowTextToArrow + kArrowWidth + kControlLeftSpace);
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0)
        {
            controlRect.origin.x -= 15;
        }
        
        self.arrowTextLabel.frame = controlRect;
    }
}

#pragma mark - Switch

- (void)switchChanged:(UISwitch *)swith
{
    if (self.switchChangedHandler)
    {
        self.switchChangedHandler(swith.on);
    }
}


@end
