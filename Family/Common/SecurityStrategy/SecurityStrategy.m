//
//  SecurityStrategy.m
//  FileBox
//
//  Created by JiaJunbo on 15/5/19.
//  Copyright (c) 2015年 OrangeTeam. All rights reserved.
//

#import "SecurityStrategy.h"
#import "AMBlurView.h"
#import "SecurityStrategy+TouchID.h"
#import "PAPasscodeViewController.h"
#import "CommonData+AppSetting.h"

#define kBlurViewTag 19999
#define kPasscodeViewTag 20000
#define kRemoveViewInterval 0.35f
#define kKeyboardAnimationDuration 0.4f

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenScale ([UIScreen mainScreen].scale)

#define kKeyboardHeight (ScreenWidth <= 375 ? 216 : 226)

#define kDelayAfterTouchID 0.1f

#define kFindPasswordAlertViewTag  100

#define kApplicationRetryLimitExceeded -1
#define kCanceledByUser -2
#define kFallbackAuthenticationMechanismSelected -3

#define kHelpHelpHelp @"999"

@interface SecurityStrategy ()
{
    BOOL    _isHelpHelpHelp;
    NSDate *_helpHelpHelpDate;
}
@property (nonatomic, strong) PAPasscodeViewController *passcodeVC;
@property (nonatomic, strong) UIButton                 *findPasswordButton;
@property (nonatomic, strong) UIAlertView              *alertView;
@end

@implementation SecurityStrategy

#pragma mark - Share Instance
+ (instancetype)instance
{
    static SecurityStrategy *__shareInstance = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{
        __shareInstance = [[super allocWithZone:nil] init];
    });
    return __shareInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self addNotificationObserver];
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if ([self class] == [SecurityStrategy class])
    {
        return [[self class] instance];
    }
    else
    {
        return [super allocWithZone:zone];
    }
}

+ (instancetype)alloc
{
    if ([self class] == [SecurityStrategy class])
    {
        return [[self class] instance];
    }
    else
    {
        return [super alloc];
    }
}

+ (instancetype)new
{
    if ([self class] == [SecurityStrategy class])
    {
        return [[self class] instance];
    }
    else
    {
        return [super new];
    }
}

#ifndef OBJC_ARC_UNAVAILABLE
+ (id)copyWithZone:(struct _NSZone *)zone
{
    if ([self class] == [SecurityStrategy class])
    {
        return [[self class] instance];
    }
    else
    {
        return [super copyWithZone:zone];
    }
}
#endif

#pragma mark - Outter Methods
+ (void)run
{
    [[self instance] enterForegroundMode];
}

+ (BOOL)isProtecting
{
    return [[[self class] instance] windowHasSubView:kBlurViewTag];
}

+ (void)turnOff
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAuthenticationSuccessNotification object:nil];
    
    // 不延时的话 会和系统的模态框消失冲突 导致莫名的延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayAfterTouchID * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[[self class] instance] turnOffAuthentication];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[self class] instance] removeBlurView];
        });
    });
}

// 开启高斯模糊
+ (BOOL)isUnderSafeMode
{
    return [[[self class] instance] readPasscodeSwitch];
}

#pragma mark - Tool Methods

- (BOOL)windowHasSubView:(NSUInteger)viewTag
{
    if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:viewTag])
    {
        return YES;
    }
    
    return NO;
}

- (void)removeViewViewClass:(Class)viewClass tag:(NSUInteger)viewTag timeInterval:(float)seconds
{
    NSArray *subViews = [[UIApplication sharedApplication] keyWindow].subviews;
    for (UIView *view in subViews)
    {
        if ([[view class] isSubclassOfClass:viewClass] && view.tag == viewTag)
        {
            [UIView animateWithDuration:seconds animations:^{
                
                view.alpha = 0;
            } completion:^(BOOL finished) {
                
                [view removeFromSuperview];
            }];
        }
    }
}

#pragma mark - Application Notification
- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundMode) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundMode) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

// 身份验证
- (void)enterForegroundMode
{
    if ([[self class] isUnderSafeMode])
    {
        [self addBlurView];
        
        [self turnOnAuthentication];
    }
}

- (void)enterBackgroundMode
{
    if ([[self class] isUnderSafeMode])
    {
        [self addBlurView];
        
        [self turnOffAuthentication];
    }
}

#pragma mark - Safe Mode

- (void)addBlurView
{
    if ([[self class] isProtecting]) return;
    
    AMBlurView *blurView = [[AMBlurView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [blurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    blurView.tag = kBlurViewTag;
    [[[UIApplication sharedApplication] keyWindow] addSubview:blurView];
}

- (void)removeBlurView
{
    [self removeViewViewClass:[AMBlurView class] tag:kBlurViewTag timeInterval:kRemoveViewInterval];
}

// 进行身份验证
- (void)turnOnAuthentication
{
    BOOL shouldVerifyTouchID = [self readTouchIDSwitch];
    
    [self addVerifyPasscodeView];
    
    if (![self handleHelpHelpHelp])
    {
        if (shouldVerifyTouchID)
        {
            [self hideKeyboard];
            
            [self verifyTouchID];
        }
    };
}

// 关闭身份验证
- (void)turnOffAuthentication
{
    [self removeVerifyPasscodeView];
    
    [self removeAlertView];
}

- (void)verifyTouchID
{
    NSString *reason = NSLocalizedString(@"验证已有指纹", nil);
    __weak __typeof(self) wself = self;
    
#pragma mark Touch ID 存在性检查
    if ([SecurityStrategy isTouchIDAvailable])
    {
#pragma mark Touch ID 开始运作
        [SecurityStrategy authenticateTouchID:reason
                                       succes:^{
                                           
                                           [SecurityStrategy turnOff];
                                       }
                                      failure:^{
                                          
                                          // 不延时的话 会和系统的模态框消失冲突 导致莫名的延时
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayAfterTouchID * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                              
                                              // Application retry limit exceeded.
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
                                                                                              message:NSLocalizedString(@"Touch ID 验证失败", nil)
                                                                                             delegate:self
                                                                                    cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          });
                                      }
                                     canceled:^{
                                         
                                         // cancel
                                         if (wself)
                                         {
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayAfterTouchID * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                 
                                                 __strong __typeof(self) self = wself;
                                                 [self showKeyboard];
                                             });
                                         }
                                     }];
    }
    else
    {
        NSLog(@"没有开启TOUCHID设备自行解决");
    }
}

#pragma mark - Passcode
- (BOOL)readPasscodeSwitch
{
    return [CommonData passwordSwitch];
}

- (NSString *)readPasscode
{
    return [CommonData password];
}

- (BOOL)readTouchIDSwitch
{
    return [CommonData touchIDSwitch];
}

- (void)addVerifyPasscodeView
{
    if ([self windowHasSubView:kPasscodeViewTag]) return;
    
    if (!self.passcodeVC)
    {
        PAPasscodeViewController *passcodeVC = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
        // passcodeVC.title = NSLocalizedString(@"验证密码", nil); // no navigation bar, so no need
        passcodeVC.passcode = [self readPasscode];
        passcodeVC.simple = YES;
        passcodeVC.inputBackgroundColor = [UIColor clearColor];
        passcodeVC.view.tag = kPasscodeViewTag;
        passcodeVC.enterConfirmedBlock = ^{
            
#pragma mark 密码输入正确
            [SecurityStrategy turnOff];
        };
        
        self.passcodeVC = passcodeVC;
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.passcodeVC.view];
    // [self presentModalVC:passcodeVC];
    
    [self addFindPasswordButtonToView:self.passcodeVC.view];
}

- (void)addFindPasswordButtonToView:(UIView *)superView
{
    if (!self.findPasswordButton)
    {
        CGRect findPasswordButtonRect;
        findPasswordButtonRect.size.width = 110;
        findPasswordButtonRect.size.height = 40;
        findPasswordButtonRect.origin.x = CGRectGetWidth([[UIScreen mainScreen] bounds]) - CGRectGetWidth(findPasswordButtonRect);
        findPasswordButtonRect.origin.y = CGRectGetHeight([[UIScreen mainScreen] bounds]) - CGRectGetHeight(findPasswordButtonRect) - kKeyboardHeight;
        findPasswordButtonRect.origin.y -= 5;
        
        UIButton *findPassword = [[UIButton alloc] initWithFrame:findPasswordButtonRect];
        [findPassword.titleLabel setTextAlignment:NSTextAlignmentRight];
        [findPassword setTitle:NSLocalizedString(@"密码忘记了？", nil) forState:UIControlStateNormal];
        [findPassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [findPassword.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [findPassword addTarget:self action:@selector(handleFindPassword) forControlEvents:UIControlEventTouchUpInside];
        // [findPassword setBackgroundColor:[UIColor redColor]];
        [superView addSubview:findPassword];
        
        self.findPasswordButton = findPassword;
    }
    
    [self.findPasswordButton setAlpha:[CommonData findPasswordQuestionEnable]];
}

- (void)removeVerifyPasscodeView
{
    [self.passcodeVC.view removeFromSuperview];
    
    if ([[self.passcodeVC typedPasscode] isEqualToString:kHelpHelpHelp])
    {
        _isHelpHelpHelp = YES;
        _helpHelpHelpDate = [NSDate date];
    }
}

#pragma mark - Alert View
#pragma mark Handle
- (void)handleFindPassword
{
    [self hideKeyboard];
    
    __weak __typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kKeyboardAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (wself)
        {
             __strong __typeof(self) self = wself;
            [self showFindPasswordAlertView];
        }
    });
}

- (BOOL)handleHelpHelpHelp
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:_helpHelpHelpDate];
    if (_isHelpHelpHelp && timeInterval < 5) // 5s
    {
        __weak __typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kKeyboardAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (wself)
            {
                __strong __typeof(self) self = wself;
                [self showPasswordAlertView];
            }
        });
        
        _isHelpHelpHelp = NO;
        return YES;
    }
    return NO;
}

#pragma mark Show Hide
- (void)showFindPasswordAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"找回密码", nil)
                                                    message:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"问题", nil), [CommonData findPasswordQuestion]]
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                          otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alert.tag = kFindPasswordAlertViewTag;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.placeholder = NSLocalizedString(@"请输入答案", nil);
    
    [alert show];
    self.alertView = alert;
}

- (void)showPasswordAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"您的密码是：", nil)
                                       message:[self readPasscode]
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"好的", nil) otherButtonTitles:nil];
    [alert show];
    self.alertView = alert;
}

- (void)showWrongAnsverAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"答案输入错误", nil)
                                       message:nil
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"好的", nil) otherButtonTitles:nil];
    [alert show];
    self.alertView = alert;
}

- (void)removeAlertView
{
    if (self.alertView)
    {
        UITextField *textField = [self.alertView textFieldAtIndex:0];
        [textField resignFirstResponder];
        
        [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
}

#pragma mark Delegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (kFindPasswordAlertViewTag == alertView.tag)
    {
        // default cancel btn
        if (0 == buttonIndex)
        {
            // cancel
        }
        else
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            [textField resignFirstResponder];
            
            __weak __typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kKeyboardAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (wself)
                {
                    __strong __typeof(self) self = wself;
                    if ([[CommonData findPasswordAnswer] isEqualToString:textField.text])
                    {
                        [self showPasswordAlertView];
                    }
                    else
                    {
                        [self showWrongAnsverAlertView];
                    }
                }
            });
            
            return;
        }
    }
    
    // 用户点击的，alertview消失后，自动把输入密码的键盘打开，否则进入后台状态，不要打开键盘
    if (self.passcodeVC.view.superview)
    {
        __weak __typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kKeyboardAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (wself)
            {
                __strong __typeof(self) self = wself;
                [self showKeyboard];
            }
        });
    }
    
    self.alertView = nil;
}

#pragma mark - Keyboard
- (void)hideKeyboard
{
    [self.passcodeVC hideKeyboard];
    [self.findPasswordButton setHidden:YES];
}

- (void)showKeyboard
{
    [self.passcodeVC showKeyboard];
    [self.findPasswordButton setHidden:NO];
}
@end
