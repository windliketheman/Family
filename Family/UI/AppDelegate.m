//
//  AppDelegate.m
//  Family
//
//  Created by jia on 15/8/13.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "TabBarViewController.h"
#import "IntroductionViewController.h"
#import "LoginViewController.h"
#import "HomelandViewController.h"
#import "MembersViewController.h"
#import "MessagesViewController.h"
#import "MineViewController.h"
#import "SettingViewController.h"
#import "PushInfoHandler.h"
#import <BaiduMapAPI/BMapKit.h>
#import "CommonData.h"
#import "UpdateChecker.h"
#import "BusinessNetworkCore.h"
#import "ServerConfig.h"
#import "SecurityStrategy.h"

#define kSkipSplashEffect 0

@interface AppDelegate ()
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) TabBarViewController *tabBarViewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 初始化窗口
    [self initWindow];
    
    // 根视图
    [self initRootVC];
    
    // 波纹动画
    // [self splashEffectComplection:^{
        // 根视图
        [self showRootVC];
    
    // 安全策略打开 验证身份
    [SecurityStrategy run];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationSuccess) name:kAuthenticationSuccessNotification object:nil];
    //}];
    
    [self asyncTodo];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
#if kUsingChatModule
    // 断开socket通道
    [self myDisConnect];
#endif
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([CommonData hasUserLogined])
    {
#if kUsingChatModule
        [self myConnect];
#endif
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];
    
    [self clearIconBadge:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    // 如果vc不支持多个方向，但此处设置了多个方向，vc不能旋转，但状态栏依然旋转
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark --- Push
- (void)registerForNotificationTypes
{
    @autoreleasepool
    {
        // IOS8 新系统需要使用新的代码咯
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                                 settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                                 categories:nil]];
            
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            //这里还是原来的代码
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                                   UIRemoteNotificationTypeSound |
                                                                                   UIRemoteNotificationTypeAlert)];
        }
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"APNS -> DeviceToken: %@", token);
    
#if kUsingAPNS
    // 把deviceToken发送到我们的推送服务器
    ChatCore *chatcore = [[ChatCore alloc] init];
    [chatcore sendTokenToServer:token
                         userID:[[CommonCore queryLoginUserId] integerValue]
                    phoneNumber:[CommonCore queryLoginUserPhone]];
#endif
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self clearIconBadge:application];
    
    [PushInfoHandler handlePushInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Local Notification: %@", [notification.userInfo description]);
}

#pragma mark - Inner Methods
- (void)initWindow
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    
    self.window = window;
}

- (void)initRootVC
{
    // 新版本有可能要展示向导
    if ([CommonData isNewVersionLaunching])
    {
        // 第一次使用app 设置初始化主题
        if ([CommonData isFirstTimeLaunching])
        {
#if kUsingTheme
            aaa[SettingTool saveThemeInfo:@"theme_1"];
#endif
        }
        
        // 需要展示向导
        if ([CommonData shouldShowAppIntroduction])
        {
            self.rootViewController = [self createIntroductionViewController];
        }
        else
        {
            // 直接进入
            self.rootViewController = [self createRootViewController];
        }
        
        [CommonData saveLaunchedAppVersion];
    }
    else
    {
        // 直接进入
        self.rootViewController = [self createRootViewController];
    }
}

- (void)authenticationSuccess
{
    //
}

- (void)splashEffectComplection:(dispatch_block_t)block
{
#ifdef DEBUG
    if (kSkipSplashEffect)
    {
        block();
        return;
    }
#endif
    
    [self delaySeconds:0.0f perform:^{
        if (block)
        {
            block();
        }
    }];
}

- (UIViewController *)createIntroductionViewController
{
    // Added Introduction View Controller
    NSArray *coverImageNames = @[@"app_introduction_0.jpg",
                                 @"app_introduction_1.jpg",
                                 @"app_introduction_2.jpg",
                                 @"app_introduction_3.jpg",
                                 @"app_introduction_4.jpg",
                                 @"app_introduction_5.jpg"];
    IntroductionViewController *introductionVC = [[IntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:nil];
    [introductionVC.view setBackgroundColor:RGBVCOLOR(0xff2d4b)];
    
    __block UIViewController *rootVC = nil;
    __weak __typeof(self) wself = self;
    
    introductionVC.didSelectedEnter = ^{
        if (wself)
        {
            __strong __typeof(self) self = wself;
            self.rootViewController = rootVC;
            [self showRootVC];
        }
    };
    
    // 点击之前，酒吧rootvc创建好，让点击更顺畅
    rootVC = [self createRootViewController];
    
    return introductionVC;
}

- (UIViewController *)createRootViewController
{
    // 判断用户是否已登录
    if (kUsingUserLogin && ![CommonData hasUserLogined])
    {
        return [self createLoginViewController];
    }
    else
    {
#if kUsingChatModule
        [self myConnect];
#endif
        
        return [self createTabBarViewController];
    }
}

- (UIViewController *)createTabBarViewController
{
    NavigationControllerConstructor ncc = ^(UINavigationController **nc, UIViewController *vc) {
        *nc = [self createNavigationControllerWithRootViewController:vc];
    };
    
    TabBarViewController *tabVC = [[TabBarViewController alloc] init];
    tabVC.tabBar.translucent = kUsingTranslucentTabBar;
    
    tabVC.tabBarItemUnselectedColor = RGBSCOLOR(146);
    tabVC.tabBarItemSelectedColor = [UIColor redColor];
    tabVC.tabBarItemTitles = @[NSLocalizedString(@"家园", nil),
                             NSLocalizedString(@"成员", nil),
                             NSLocalizedString(@"消息", nil),
                             NSLocalizedString(@"我", nil)];
    tabVC.tabBarItemTitleOffset = UIOffsetMake(0, -2);
    tabVC.tabBarItemImageNames = @[@"tabbar_icon_files",
                                 @"tabbar_icon_mark",
                                 @"tabbar_icon_history",
                                 @"tabbar_icon_setting"];
    tabVC.contentClasses = @[[HomelandViewController class],
                           [MembersViewController class],
                           [MessagesViewController class],
                           [SettingViewController class]];
    tabVC.navigationControllerConstructor = ncc;
    [tabVC loadChildViewControllers];
    
    self.tabBarViewController = tabVC;
    
    return tabVC;
}

- (UIViewController *)createLoginViewController
{
    // 如果不是第一次启动的话, 使用LoginViewController作为根视图
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    
    return [self createNavigationControllerWithRootViewController:loginViewController];
}

- (BaseNavigationController *)createNavigationControllerWithRootViewController:(UIViewController *)rootViewController
{
    BaseNavigationController *navigationController = [[BaseNavigationController alloc] initWithRootViewController:rootViewController];
    
    return navigationController;
}

- (void)showRootVC
{
    // 状态栏初始是隐藏的，把它显示出来
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.window.rootViewController = self.rootViewController;
}

- (void)asyncTodo
{
    // 读取配置
    [CommonData setMainConfigFile:ServerConfig];
    
#if kUsingChatModule
    // 设置xmpp协议相关
    [self setupXMPP];
#endif
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 初始化数据库文件
        [self initDatabase];
        
        // 注册业务的网络核心
        [BusinessNetworkCore doRegister];
        
        // 百度地图API
        if (![[[BMKMapManager alloc] init] start:@"YQMgOZ5fkUGKTYH4UhDKCoAV" generalDelegate:nil])
        {
            NSLog(@"manager strat filed!");
        }
        
        [self checkUpdateInfo];
    });
}

#pragma mark - Tools
- (void)clearIconBadge:(UIApplication *)app
{
    app.applicationIconBadgeNumber = 0;
}

- (void)delaySeconds:(float)seconds perform:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

- (void)checkUpdateInfo
{
    return;
    
    UpdateChecker *checker = [[UpdateChecker alloc] init];
    checker.innerPromptUpdate = YES;
    [checker checkAppID:kAppID name:AppName version:AppVersion];
}

#pragma mark - Database
- (void)initDatabase
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [self applicationDocumentsDirectory];
    path = [path stringByAppendingPathComponent:@"family.sqlite"];
    
    //copy the sqlite file to documents directory
    if (![fm fileExistsAtPath:path])
    {
        NSString *pathInBundle = [[NSBundle mainBundle] pathForResource:@"family" ofType:@"sqlite"];
        NSError *error;
        [fm copyItemAtPath:pathInBundle toPath:path error:&error];
    }
}

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
