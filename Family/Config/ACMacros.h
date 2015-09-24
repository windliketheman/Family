//
//  ACMacros.h
//


#ifndef ACMacros_h
#define ACMacros_h


//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


/** DEBUG RELEASE **/
#if DEBUG

#define MCRelease(x)            [x release]

#else

#define MCRelease(x)            [x release], x = nil

#endif


/** NIL RELEASE **/
#define NILRelease(x)           [x release], x = nil


/* ****************************************************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

// 系统控件默认高度
#define kStatusBarHeight            20.f
#define kNavigationBarHeight        44.0f
#define kNavigationBarShortHeight   32.0f

#define kTopBarHeight               38.5f
#define kSystemTabBarHeight         49.0
#define kSystemToolBarHeight        44.0

#define kCellDefaultHeight          44.f

#define kEnglishKeyboardHeight      216.f
#define kChineseKeyboardHeight      252.f

#define KeyBoardH (60.f)
/* ****************************************************************************************************************** */
#define LOGOPEN 1
#define VC_LOGOPEN 1
#define DB_BLOCK_LOG
#define NET_BLOCK_LOG 1


#pragma mark ---log  flag

#define LogFrame(frame) NSLog(@"frame[X=%.1f,Y=%.1f,W=%.1f,H=%.1f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)
#define LogPoint(point) NSLog(@"Point[X=%.1f,Y=%.1f]",point.x,point.y)

#if LOGOPEN
#define DDDLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DDDLog(FORMAT, ...)
#endif

//viewController log
#ifdef VC_LOGOPEN
#define LogVC DDDLog
#else
#define LogVC
#endif

//dbbase log
#ifdef DB_BLOCK_LOG
#define LogDB DDDLog
#else
#define LogDB
#endif


//networking log
#if NET_BLOCK_LOG
#define LogNET DDDLog
#else
#define LogNET
#endif

//view log
#ifdef VIEW_BLOCK_LOG
#define LogVIEW DDDLog
#else
#define LogVIEW
#endif


#pragma mark --time setup


#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#endif

#ifdef  _DEBUG
#define DNSLog(...);    NSLog(__VA_ARGS__);
#define DNSLogMethod    NSLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd));
#define DNSLogPoint(p)  NSLog(@"%f,%f", p.x, p.y);
#define DNSLogSize(p)   NSLog(@"%f,%f", p.width, p.height);
#define DNSLogRect(p)   NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);

CFAbsoluteTime startTime;
#define D_START         startTime=CFAbsoluteTimeGetCurrent();
#define D_END           DNSLog(@"[%s] %@ %f seconds", class_getName([self class]), NSStringFromSelector(_cmd), CFAbsoluteTimeGetCurrent() - startTime );
#else
#define DNSLog(...);    // NSLog(__VA_ARGS__);
#define DNSLogMethod    // NSLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd) );
#define DNSLogPoint(p)  // NSLog(@"%f,%f", p.x, p.y);
#define DNSLogSize(p)   // NSLog(@"%f,%f", p.width, p.height);
#define DNSLogRect(p)   // NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);

#define D_START         // CFAbsoluteTime startTime=CFAbsoluteTimeGetCurrent();
#define D_END           // DNSLog(@"New %f seconds", CFAbsoluteTimeGetCurrent() - startTime );
#endif

#define SAFE_FREE(p) { if(p) { free(p); (p)=NULL; } }

#pragma mark ---- AppDelegate
//AppDelegate
#define APPDELEGATE [(AppDelegate*)[UIApplication sharedApplication]  delegate]

#pragma mark ---- String  functions
#define EMPTY_STRING        @""
#define STR(key)            NSLocalizedString(key, nil)


#pragma mark ---- UIImage  UIImageView  functions
#define IMG(name) [UIImage imageNamed:name]
#define IMGF(name) [UIImage imageNamedFixed:name]

#pragma mark ---- File  functions
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#pragma mark ----Size ,X,Y, View ,Frame
//get the  size of the Screen
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define HEIGHT_SCALE  ([[UIScreen mainScreen]bounds].size.height/480.0)

//get the  size of the Application
#define APP_HEIGHT [[UIScreen mainScreen]applicationFrame].size.height
#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width

#define APP_SCALE_H  ([[UIScreen mainScreen]applicationFrame].size.height/480.0)
#define APP_SCALE_W  ([[UIScreen mainScreen]applicationFrame].size.width/320.0)
/* ****************************************************************************************************************** */
#pragma mark - Funtion Method (宏 方法)

// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBSCOLOR(sameValue)    [UIColor colorWithRed:(sameValue)/255.0 green:(sameValue)/255.0 blue:(sameValue)/255.0 alpha:1]
#define RGBASCOLOR(sameValue,a) [UIColor colorWithRed:(sameValue)/255.0 green:(sameValue)/255.0 blue:(sameValue)/255.0 alpha:(a)]
#define RGBVCOLOR(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue \
                                & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0] //RGBVCOLOR(0x3c3c3c)
#define RGBAVCOLOR(rgbValue,a)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue \
                                & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)] //RGBVCOLOR(0x3c3c3c, 0.5)

//图片高度缩放比例
#define ImageHight(h)           Main_Screen_Height/(h)
#define ImageWidth(w)           Main_Screen_Width/(w)
// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES];\
                                [View.layer setBorderWidth:(Width)];\
                                [View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES]

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

//手机型号
#define PhoneModel              ([[UIDevice currentDevice] model])

// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 是否Retina屏
#define isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 960), \
                                                  [[UIScreen mainScreen] currentMode].size) : \
                                NO)

// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 1136), \
                                                  [[UIScreen mainScreen] currentMode].size) : \
                                NO)
// 是否iPhone6
#define isiPhone6     (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)

// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define ApplicationDelegate     (AppDelegate *)[[UIApplication sharedApplication] delegate]

// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
                                \
                                [_OBJECT viewWithTag : _TAG]

// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString1(x, ...)     NSLocalizedString(x, nil)
#define LocalString(x)     ([StringsUtil getLocalString:x])
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
                                \
                                [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                 blue:((float)(rgbValue & 0xFF))/255.0 \
                                                alpha:1.0]

// 跨设备的尺寸转换
#define kDesignWidth                      750.0f
#define kDesignScale                      2.0f
#define kScreenWidth                      [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight                     [[UIScreen mainScreen] bounds].size.height
#define kScreenScale                      [[UIScreen mainScreen] scale]
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

// 传入设计图上标注的或直接从设计图上测量出的数值，不是跨设备的
#define CGViewWidth(w)                    floorf((w) / kDesignScale)
#define CGViewHeight(h)                   floorf((h) / kDesignScale)
#define CGViewSize(w, h)                  CGSizeMake(CGViewWidth(w), CGViewHeight(h))

// 传入设计图上标注的或直接从设计图上测量出的文字高度，不是跨设备的，不同设备数值相同
#define CGLabelHeight(textHeight)         ((textHeight) / kDesignScale + 2 + 2) // real size + top + bottom
#define CGLabelFontSize(textHeight)       ((textHeight) / kDesignScale)

// 传入设计图上标注的或直接从设计图上测量出的文字高度，屏幕宽度不超过6的一致，6plus在6的基础上乘以放大因子
#define CGLabelCrocessDeviceHeight(textHeight)    (kScreenWidth > kDesignWidth ? \
                                                  ((textHeight)/kDesignScale * kScaleFactor + 2 + 2) : CGLabelHeight(textHeight))
#define CGLabelCrocessDeviceFontSize(textHeight)  (kScreenWidth > kDesignWidth ? \
                                                  CGLabelFontSize * kScaleFactor : CGLabelFontSize)


#define kNavigationBarBGColor             RGBCOLOR(255, 255, 255)
#define kNavigationBarTitleColor          RGBCOLOR(52, 52, 52)
#define kNavigationBarItemColor           RGBSCOLOR(0)

#define kAppID                    @"1020541636"
#define AppVersion                ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define AppFullVersion            ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
#define AppName                   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

#define SystemVersion            ([[[UIDevice currentDevice] systemVersion] floatValue])

#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif

// ARC
#if __has_feature(objc_arc)
/** Compiling with ARC */
#else
/** Compiling without ARC */
#endif


/* ****************************************************************************************************************** */
#pragma mark - Log Method (宏 LOG)

// 日志 / 断点
// =============================================================================================================================
// DEBUG模式
#define ITTDEBUG

// LOG等级
#define ITTLOGLEVEL_INFO        10
#define ITTLOGLEVEL_WARNING     3
#define ITTLOGLEVEL_ERROR       1

// =============================================================================================================================
// LOG最高等级
#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

// =============================================================================================================================
// LOG PRINT
// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)      NSLog(@"< %s:(%d) > : " xx , __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)      ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME()   ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)      ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)      ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)    ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)    ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)       ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)       ((void)0)
#endif

// 条件LOG
#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...)\
                                \
                                {\
                                    if ((condition))\
                                    {\
                                        ITTDPRINT(xx, ##__VA_ARGS__);\
                                    }\
                                }
#else
#define ITTDCONDITIONLOG(condition, xx, ...)\
                                \
                                ((void)0)
#endif

// 断点Assert
#define ITTAssert(condition, ...)\
                                \
                                do {\
                                    if (!(condition))\
                                    {\
                                        [[NSAssertionHandler currentHandler]\
                                        handleFailureInFunction:[NSString stringWithFormat:@"< %s >", __PRETTY_FUNCTION__]\
                                                           file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent]\
                                                     lineNumber:__LINE__\
                                                    description:__VA_ARGS__];\
                                    }\
                                } while(0)


/* ****************************************************************************************************************** */
#pragma mark - Constants (宏 常量)


/** 时间间隔 */
#define kHUDDuration            (1.f)

/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)
/** 秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))

/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** 毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))


//** textAlignment ***********************************************************************************

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
# define TextAlignmentLeft UITextAlignmentLeft
# define TextAlignmentCenter UITextAlignmentCenter
# define TextAlignmentRight UITextAlignmentRight

#else
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
# define TextAlignmentLeft NSTextAlignmentLeft
# define TextAlignmentCenter NSTextAlignmentCenter
# define TextAlignmentRight NSTextAlignmentRight

#endif



#endif
