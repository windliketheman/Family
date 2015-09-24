//
//  PAPasscodeViewController.m
//  PAPasscode
//
//  Created by Denis Hennessy on 15/10/2012.
//  Copyright (c) 2012 Peer Assembly. All rights reserved.
//

#import "PAPasscodeViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kScreenWidth                      [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight                     [[UIScreen mainScreen] bounds].size.height
#define kScreenScale                      [[UIScreen mainScreen] scale]

// 跨设备的尺寸转换
#define kDesignWidth                      640.0f
#define kDesignScale                      2.0f

#define kScaleFactor                      (kScreenWidth / kDesignWidth)

// 传入设计图上标注的或直接从设计图上测量出的数值，是跨设备的
#define CGCrossDeviceX(x)                 floorf((x) * kScaleFactor)
#define CGCrossDeviceY(y)                 floorf((y) * kScaleFactor)
#define CGCrossDeviceWidth(w)             floorf((w) * kScaleFactor)
#define CGCrossDeviceHeight(h)            floorf((h) * kScaleFactor)
#define CGCrossDevicePointMake(x, y)      CGPointMake(CGCrossDeviceX(x), CGCrossDeviceY(y))
#define CGCrossDeviceSizeMake(w, h)       CGSizeMake(CGCrossDeviceWidth(w), CGCrossDeviceHeight(h))
#define CGCrossDeviceRectMake(x, y, w, h) CGRectMake(CGCrossDeviceX(x), CGCrossDeviceY(y), \
CGCrossDeviceWidth(w), CGCrossDeviceHeight(h))

#define PROMPT_HEIGHT   CGCrossDeviceHeight(152)
#define DIGIT_SPACING   CGCrossDeviceWidth(20)
#define DIGIT_WIDTH     CGCrossDeviceWidth(122)
#define DIGIT_HEIGHT    CGCrossDeviceHeight(106)
#define MARKER_WIDTH    CGCrossDeviceWidth(32)
#define MARKER_HEIGHT   CGCrossDeviceHeight(32)

#define MESSAGE_HEIGHT  PROMPT_HEIGHT

#define FAILED_LCAP     19
#define FAILED_RCAP     19
#define FAILED_HEIGHT   26
#define FAILED_MARGIN   10
#define TEXTFIELD_MARGIN 8
#define SLIDE_DURATION  0.3

@interface UIImage (Color)
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
@end
@implementation UIImage (Color)
- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
@end

@interface PAPasscodeViewController ()
- (void)cancel:(id)sender;
- (void)handleFailedAttempt;
- (void)handleCompleteField;
- (void)passcodeChanged:(id)sender;
- (void)resetFailedAttempts;
- (void)showFailedAttempts;
- (void)showScreenForPhase:(NSInteger)phase animated:(BOOL)animated;
@end

@implementation PAPasscodeViewController

- (id)initForAction:(PasscodeAction)action
{
    self = [super init];
    if (self)
    {
        _action = action;
        switch (action)
        {
            case PasscodeActionSet:
                self.title = NSLocalizedString(@"设置密码", nil); // NSLocalizedString(@"Set Passcode", nil);
                _enterPrompt = NSLocalizedString(@"输入密码", nil); // NSLocalizedString(@"Enter a passcode", nil);
                _confirmPrompt = NSLocalizedString(@"再次输入密码", nil); // NSLocalizedString(@"Re-enter your passcode", nil);
                break;
                
            case PasscodeActionEnter:
                self.title = NSLocalizedString(@"输入密码", nil); // NSLocalizedString(@"Enter Passcode", nil);
                _enterPrompt = NSLocalizedString(@"请输入密码", nil); // NSLocalizedString(@"Enter your passcode", nil);
                break;
                
            case PasscodeActionChange:
                self.title = NSLocalizedString(@"修改密码", nil); // NSLocalizedString(@"Change Passcode", nil);
                _changePrompt = NSLocalizedString(@"输入旧的密码", nil); // NSLocalizedString(@"Enter your old passcode", nil);
                _enterPrompt = NSLocalizedString(@"输入新的密码", nil); // NSLocalizedString(@"Enter your new passcode", nil);
                _confirmPrompt = NSLocalizedString(@"再次输入新的密码", nil); // NSLocalizedString(@"Re-enter your new passcode", nil);
                break;
        }
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        // 使屏幕原点始终为屏幕左上角，（否则，当导航栏不透明时，原点为导航栏左下角）
        self.extendedLayoutIncludesOpaqueBars = YES;
        _simple = YES;
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = self.inputBackgroundColor ? self.inputBackgroundColor : [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    self.view = view;
    
    CGRect contentViewRect = self.view.bounds;
    contentViewRect.origin.y += 64;
    contentViewRect.size.height -= CGRectGetMinY(contentViewRect);
    contentView = [[UIView alloc] initWithFrame:contentViewRect];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // contentView.backgroundColor = [UIColor greenColor];
    [view addSubview:contentView];
    
    UIColor *promptTextColor = [UIColor colorWithRed:77.0f/255 green:77.0f/255 blue:77.0f/255 alpha:1.0];
    promptTextColor = [UIColor blackColor];
    
    CGFloat panelWidth = DIGIT_WIDTH*4+DIGIT_SPACING*3;
    if (_simple)
    {
        float screenWidth = kScreenWidth;
        CGRect digitPanelRect = CGRectMake(0, 0, panelWidth, DIGIT_HEIGHT);
        UIView *digitPanel = [[UIView alloc] initWithFrame:digitPanelRect];
        digitPanel.frame = CGRectOffset(digitPanel.frame,
                                        (contentView.bounds.size.width-digitPanel.bounds.size.width)/2,
                                        PROMPT_HEIGHT);
        digitPanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        // digitPanel.backgroundColor = [UIColor yellowColor];
        [contentView addSubview:digitPanel];
        
        UIImage *markerImage = [[UIImage imageNamed:@"papasscode_marker"] imageWithTintColor:promptTextColor];
        CGFloat xLeft = 0;
        for (int i = 0; i < 4; i++)
        {
            CGRect digitViewRect;
            digitViewRect.origin = CGPointZero;
            digitViewRect.size = CGSizeMake(DIGIT_WIDTH, DIGIT_HEIGHT);
            digitViewRect.origin.x = xLeft;
            UIView *digitView = [[UIView alloc] initWithFrame:digitViewRect];
            digitView.layer.borderColor = promptTextColor.CGColor;
            digitView.layer.borderWidth = 1.0f/[[UIScreen mainScreen] scale];
            // digitImageView.backgroundColor = [UIColor blueColor];
            [digitPanel addSubview:digitView];
            
            
            digitImageViews[i] = [[UIImageView alloc] initWithImage:markerImage];
            digitImageViews[i].autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            digitImageViews[i].frame = CGRectOffset(digitImageViews[i].frame,
                                                    digitView.frame.origin.x + (CGRectGetWidth(digitView.frame) - CGRectGetWidth(digitImageViews[i].frame))/2,
                                                    (CGRectGetHeight(digitView.frame) - CGRectGetHeight(digitImageViews[i].frame))/2);
            // digitImageViews[i].backgroundColor = [UIColor redColor];
            [digitPanel addSubview:digitImageViews[i]];
            
            xLeft += CGRectGetWidth(digitView.frame) + DIGIT_SPACING;
        }
        
        passcodeTextField = [[UITextField alloc] initWithFrame:digitPanel.frame];
        passcodeTextField.hidden = YES;
    }
    else
    {
        UIView *passcodePanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelWidth, DIGIT_HEIGHT)];
        passcodePanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        passcodePanel.frame = CGRectOffset(passcodePanel.frame, (contentView.bounds.size.width-passcodePanel.bounds.size.width)/2, PROMPT_HEIGHT);
        passcodePanel.frame = CGRectInset(passcodePanel.frame, TEXTFIELD_MARGIN, TEXTFIELD_MARGIN);
        passcodePanel.layer.borderColor = [UIColor colorWithRed:0.65 green:0.67 blue:0.70 alpha:1.0].CGColor;
        passcodePanel.layer.borderWidth = 1.0;
        passcodePanel.layer.cornerRadius = 5.0;
        passcodePanel.layer.shadowColor = [UIColor whiteColor].CGColor;
        passcodePanel.layer.shadowOffset = CGSizeMake(0, 1);
        passcodePanel.layer.shadowOpacity = 1.0;
        passcodePanel.layer.shadowRadius = 1.0;
        passcodePanel.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:passcodePanel];
        passcodeTextField = [[UITextField alloc] initWithFrame:CGRectInset(passcodePanel.frame, 6, 6)];
    }
    passcodeTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    passcodeTextField.borderStyle = UITextBorderStyleNone;
    passcodeTextField.secureTextEntry = YES;
    passcodeTextField.textColor = [UIColor colorWithRed:0.23 green:0.33 blue:0.52 alpha:1.0];
    passcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [passcodeTextField addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:passcodeTextField];

    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, PROMPT_HEIGHT)];
    promptLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.textColor = promptTextColor;
    promptLabel.font = [UIFont boldSystemFontOfSize:18];
    // promptLabel.shadowColor = [UIColor whiteColor];
    // promptLabel.shadowOffset = CGSizeMake(0, 1);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 0;
    [contentView addSubview:promptLabel];
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PROMPT_HEIGHT+DIGIT_HEIGHT, contentView.bounds.size.width, MESSAGE_HEIGHT)];
    messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor colorWithRed:185.0f/255 green:19.0f/255 blue:19.0f/255 alpha:1.0]; // [UIColor colorWithRed:0.30 green:0.34 blue:0.42 alpha:1.0];
    messageLabel.font = [UIFont boldSystemFontOfSize:15];
    // messageLabel.shadowColor = [UIColor whiteColor];
    // messageLabel.shadowOffset = CGSizeMake(0, 1);
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
	messageLabel.text = _message;
    [contentView addSubview:messageLabel];
        
    UIImage *failedBg = [[UIImage imageNamed:@"papasscode_failed_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, FAILED_LCAP, 0, FAILED_RCAP)];
    failedImageView = [[UIImageView alloc] initWithImage:failedBg];
    failedImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    failedImageView.hidden = YES;
    [contentView addSubview:failedImageView];
    
    failedAttemptsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    failedAttemptsLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    failedAttemptsLabel.backgroundColor = [UIColor clearColor];
    failedAttemptsLabel.textColor = [UIColor whiteColor];
    failedAttemptsLabel.font = [UIFont boldSystemFontOfSize:15];
    // failedAttemptsLabel.shadowColor = [UIColor blackColor];
    // failedAttemptsLabel.shadowOffset = CGSizeMake(0, -1);
    failedAttemptsLabel.textAlignment = NSTextAlignmentCenter;
    failedAttemptsLabel.hidden = YES;
    [contentView addSubview:failedAttemptsLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];

    if (_failedAttempts > 0)
    {
        [self showFailedAttempts];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showScreenForPhase:0 animated:NO];
    
    [self showKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hideKeyboard];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)cancel:(id)sender
{
    [self.passcodeDelegate PAPasscodeViewControllerDidCancel:self];
}

#pragma mark - implementation helpers

- (void)showKeyboard
{
    [passcodeTextField becomeFirstResponder];
}

- (void)hideKeyboard
{
    [passcodeTextField resignFirstResponder];
}

- (void)handleCompleteField
{
    NSString *text = passcodeTextField.text;
    switch (_action)
    {
        case PasscodeActionSet:
            if (phase == 0)
            {
                _passcode = text;
                messageLabel.text = @"";
                [self showScreenForPhase:1 animated:YES];
            }
            else
            {
                if ([text isEqualToString:_passcode])
                {
                    if ([self.passcodeDelegate respondsToSelector:@selector(PAPasscodeViewControllerDidSetPasscode:)])
                    {
                        [self.passcodeDelegate PAPasscodeViewControllerDidSetPasscode:self];
                    }
                }
                else
                {
                    [self showScreenForPhase:0 animated:YES];
                    messageLabel.text = NSLocalizedString(@"密码不匹配，请重新输入", nil); // NSLocalizedString(@"Passcodes did not match. Try again.", nil);
                }
            }
            break;
            
        case PasscodeActionEnter:
            if ([text isEqualToString:_passcode])
            {
                [self resetFailedAttempts];
                if ([self.passcodeDelegate respondsToSelector:@selector(PAPasscodeViewControllerDidEnterPasscode:)])
                {
                    [self.passcodeDelegate PAPasscodeViewControllerDidEnterPasscode:self];
                }
                
                if (self.enterConfirmedBlock)
                {
                    self.enterConfirmedBlock();
                }
            }
            else
            {
                [self handleFailedAttempt];
                [self showScreenForPhase:0 animated:NO];
            }
            break;
            
        case PasscodeActionChange:
            if (phase == 0)
            {
                if ([text isEqualToString:_passcode])
                {
                    [self resetFailedAttempts];
                    [self showScreenForPhase:1 animated:YES];
                }
                else
                {
                    [self handleFailedAttempt];
                    [self showScreenForPhase:0 animated:NO];
                }
            }
            else if (phase == 1)
            {
                _passcode = text;
                messageLabel.text = @"";
                [self showScreenForPhase:2 animated:YES];
            }
            else
            {
                if ([text isEqualToString:_passcode])
                {
                    if ([self.passcodeDelegate respondsToSelector:@selector(PAPasscodeViewControllerDidChangePasscode:)])
                    {
                        [self.passcodeDelegate PAPasscodeViewControllerDidChangePasscode:self];
                    }
                }
                else
                {
                    [self showScreenForPhase:1 animated:YES];
                    messageLabel.text = NSLocalizedString(@"密码不匹配，请重新输入", nil); // NSLocalizedString(@"Passcodes did not match. Try again.", nil);
                }
            }
            break;
    }
}

- (void)handleFailedAttempt
{
    _failedAttempts++;
    [self showFailedAttempts];
    if ([self.passcodeDelegate respondsToSelector:@selector(PAPasscodeViewController:didFailToEnterPasscode:)])
    {
        [self.passcodeDelegate PAPasscodeViewController:self didFailToEnterPasscode:_failedAttempts];
    }
}

- (void)resetFailedAttempts
{
    messageLabel.hidden = NO;
    failedImageView.hidden = YES;
    failedAttemptsLabel.hidden = YES;
    _failedAttempts = 0;
}

- (void)showFailedAttempts
{
    messageLabel.hidden = YES;
    failedImageView.hidden = NO;
    failedAttemptsLabel.hidden = NO;
    failedAttemptsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"输入错误 %d次", nil), _failedAttempts];
    [failedAttemptsLabel sizeToFit];
    
    CGFloat bgWidth = failedAttemptsLabel.bounds.size.width + FAILED_MARGIN*2;
    CGFloat x = floor((contentView.bounds.size.width-bgWidth)/2);
    CGFloat y = PROMPT_HEIGHT+DIGIT_HEIGHT+floor((MESSAGE_HEIGHT)/2);
    failedImageView.frame = CGRectMake(x, y, bgWidth, CGRectGetHeight(failedImageView.frame));
    
    x = failedImageView.frame.origin.x+FAILED_MARGIN;
    y = failedImageView.frame.origin.y+floor((failedImageView.bounds.size.height-failedAttemptsLabel.frame.size.height)/2);
    failedAttemptsLabel.frame = CGRectMake(x, y, failedAttemptsLabel.bounds.size.width, failedAttemptsLabel.bounds.size.height);
}

- (void)passcodeChanged:(id)sender
{
    NSString *text = passcodeTextField.text;
    if (_simple)
    {
        if ([text length] > 4)
        {
            text = [text substringToIndex:4];
        }
        
        for (int i=0;i<4;i++)
        {
            digitImageViews[i].hidden = i >= [text length];
        }
        
        if ([text length] == 4)
        {
            [self handleCompleteField];
        }
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = [text length] > 0;
    }
}

- (NSString *)typedPasscode
{
    return passcodeTextField.text;
}

- (void)showScreenForPhase:(NSInteger)newPhase animated:(BOOL)animated
{
    CGFloat dir = (newPhase > phase) ? 1 : -1;
    if (animated)
    {
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        snapshotImageView = [[UIImageView alloc] initWithImage:snapshot];
        snapshotImageView.frame = CGRectOffset(snapshotImageView.frame, -contentView.frame.size.width*dir, 0);
        [contentView addSubview:snapshotImageView];
    }
    phase = newPhase;
    passcodeTextField.text = @"";
    if (!_simple)
    {
        BOOL finalScreen = _action == PasscodeActionSet && phase == 1;
        finalScreen |= _action == PasscodeActionEnter && phase == 0;
        finalScreen |= _action == PasscodeActionChange && phase == 2;
        if (finalScreen)
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleCompleteField)];
        }
        else
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"下一步", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(handleCompleteField)];
        }
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    switch (_action)
    {
        case PasscodeActionSet:
            if (phase == 0)
            {
                promptLabel.text = _enterPrompt;
            }
            else
            {
                promptLabel.text = _confirmPrompt;
            }
            break;
            
        case PasscodeActionEnter:
            promptLabel.text = _enterPrompt;
            break;
            
        case PasscodeActionChange:
            if (phase == 0)
            {
                promptLabel.text = _changePrompt;
            }
            else if (phase == 1)
            {
                promptLabel.text = _enterPrompt;
            }
            else
            {
                promptLabel.text = _confirmPrompt;
            }
            break;
    }
    
    for (int i=0;i<4;i++)
    {
        digitImageViews[i].hidden = YES;
    }
    
    if (animated)
    {
        contentView.frame = CGRectOffset(contentView.frame, contentView.frame.size.width*dir, 0);
        
        [UIView animateWithDuration:SLIDE_DURATION
                         animations:^() {
                             contentView.frame = CGRectOffset(contentView.frame, -contentView.frame.size.width*dir, 0);
                         }
                         completion:^(BOOL finished) {
                             [snapshotImageView removeFromSuperview];
                             snapshotImageView = nil;
                         }];
    }
}

@end
