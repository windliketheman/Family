//
//  CommonCore.m
//  jinherIU
//  公共方法类
//  Created by mijibao on 14-6-17.
//  Copyright (c) 2014年 Beyondsoft. All rights reserved.


#import "CommonCore.h"
#import <objc/runtime.h>

@implementation CommonCore
@synthesize networkQueue;

#pragma mark - File Path
#pragma mark File Path
+ (NSString *)relativePathFromAbsolutePath:(NSString *)fullPath
{
    if ([fullPath hasPrefix:[self systemDocumentFolder]])
    {
        NSRange documentsRange = [fullPath rangeOfString:[self systemDocumentFolder]];
        return [fullPath substringFromIndex:documentsRange.location + documentsRange.length];
    }
    
    return nil;
}

+ (NSString *)relativePathToAbsolutePath:(NSString *)filePath
{
    return [[self systemDocumentFolder] stringByAppendingPathComponent:filePath];
}

+ (NSString *)systemDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

#pragma mark - Others

//获取99信息文本大小
+ (CGSize)getNoticeTextSize:(NSString *)message :(NSInteger)fontSize :(NSInteger)maxChatWidth {
    CGSize textSize={maxChatWidth,10000.0};
    CGSize size=[message sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
}

//获取文本大小
+ (CGSize)getTextSize:(NSString *)message :(NSInteger)fontSize :(NSInteger)maxChatWidth {

    CGSize size=[message boundingRectWithSize:CGSizeMake(maxChatWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

//生产GUID
+ (NSString *)GUID {
    CFUUIDRef uuidObj=CFUUIDCreate(NULL);
    CFStringRef strguid=CFUUIDCreateString(NULL, uuidObj);
    NSString *guid=(__bridge_transfer NSString *)strguid;
    CFRelease(uuidObj);
    //guid=[guid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    guid=[guid lowercaseString];
    return  guid;
}

//文件是否存在
+ (BOOL)isExistFile:(NSString *)filePath
{
    if (!filePath || [filePath isEqualToString:@""])
    {
        return NO;
    }
    
    NSString *pathTarget = [[self systemDocumentFolder] lastPathComponent];
    NSRange targetRange = [filePath rangeOfString:pathTarget];
    if (targetRange.location != NSNotFound)
    {
        NSString *relativePath = [filePath substringFromIndex:targetRange.location + targetRange.length];
        return [[NSFileManager defaultManager] fileExistsAtPath:[self relativePathToAbsolutePath:relativePath]];
    }
    
    return NO;
    
}

//时间显示
+ (NSString *)showTimeString:(NSString *)time{
    NSString *result=@"";
    NSDate *today=[NSDate date];
    NSDate *date=[self stringToDate:time :@"yyyy-MM-dd HH:mm:ss"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *datecomps=[calendar components:unitFlags fromDate:date];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *beforeyesterday, *yesterday;
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeyesterday = [today dateByAddingTimeInterval: -secondsPerDay*2];
    
    NSString *todayString = [[self dateToString:today :@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    NSString *yesterdayString = [[self dateToString:yesterday :@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    NSString *beforeyesterdayString = [[self dateToString:beforeyesterday :@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    
    NSString *year=[self dateToString:today :@"yyyy"];
    NSString *timeyear=[time substringToIndex:4];
    NSString *dateString = [time substringToIndex:10];
    
    //获取时间,如果是英文的,放在时间的后面
    NSString *timeShow=[self timeQuantum:[datecomps hour]];
    NSString *dateShow=[self dateToString:date :@"HH:mm"];
    NSString *timeAndDate=@"";
    if ([timeShow isEqualToString:@"AM"]) {
        
        timeAndDate=[NSString stringWithFormat:@" %@%@",dateShow,timeShow];
        
    }
    else if([timeShow isEqualToString:@"PM"]) {
        timeAndDate=[NSString stringWithFormat:@" %@%@",dateShow,timeShow];
    }
    else
    {
        timeAndDate=[NSString stringWithFormat:@"%@ %@",timeShow,dateShow];
    }
    
    if ([dateString isEqualToString:todayString]){
        //今天
        result=[NSString stringWithFormat:@"%@",result];
        
        result=[NSString stringWithFormat:@"%@%@",result,timeAndDate];
        
        
    }
    else if ([dateString isEqualToString:yesterdayString]){
        
        //昨天
        result=[NSString stringWithFormat:@"%@%@",result,@"昨天"];
        
        result=[NSString stringWithFormat:@"%@%@",result,timeAndDate];
        
    }
    else if ([dateString isEqualToString:beforeyesterdayString]){
        //前天
        NSString *beforeYesterday=@"前天";
        if ([beforeYesterday isEqualToString:@"前天"]) {
            result=beforeYesterday;
            result=[NSString stringWithFormat:@"%@%@",result,timeAndDate];
        }
        else
        {
            result=[NSString stringWithFormat:@"%@ %@",[self dateToString:date :@"MM-dd"],[self dateToString:date :@"HH:mm"]]; 
        }
        
    }
    else if ([year isEqualToString:timeyear]){
        result=[NSString stringWithFormat:@"%@ %@",[self dateToString:date :@"MM-dd"],[self dateToString:date :@"HH:mm"]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ %@",dateString,[self dateToString:date :@"HH:mm"]];
//        return dateString;
    }
    
    return result;
    
}


+ (NSString *)AlbumshowTimeString:(NSString *)time{
    NSString *result=@"";
    NSDate *today=[NSDate date];
    NSDate *date=[self stringToDate:time :@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *beforeyesterday, *yesterday;
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeyesterday = [today dateByAddingTimeInterval: -secondsPerDay*2];
    
    NSString *todayString = [[self dateToString:today :@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    NSString *yesterdayString = [[self dateToString:yesterday :@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    NSString *beforeyesterdayString = [[self dateToString:beforeyesterday :@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    
    NSString *dateString = [time substringToIndex:10];
    
    //获取时间,如果是英文的,放在时间的后面
    NSString *dateShow=[self dateToString:date :@"HH:mm"];
    
    if ([dateString isEqualToString:todayString]){
        //今天
        result=dateShow;
    }
    else if ([dateString isEqualToString:yesterdayString]){
        //昨天
        result=@"昨天";
    }
    else if ([dateString isEqualToString:beforeyesterdayString]){
        //前天
        result=@"前天";
        
    }
    else
    {
        result=dateString;
    }
    
    return result;
    
}
//时间输出
+ (NSString *)timeQuantum:(NSInteger) hour{
    
    if(hour>=1&&hour<6){
        //凌晨
        return @"凌晨";
    }else if (hour>=6&&hour<9){
        //早上
        return @"早上";
    }else if (hour>=9&&hour<12){
        //上午
        return @"上午";
    }else if(hour>=12&&hour<18){
        //下午
        return @"下午";
    }else{
        //晚上
        return @"晚上";
    }
    
}

//相册时间显示

//字符串转时间
+ (NSDate *)stringToDate:(NSString *)dateString :(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

//时间转字符串
+ (NSString *)dateToString:(NSDate *)date :(NSString *)format {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
    
}

//时间差
+ (NSTimeInterval)timeIntervalBetween:(NSDate *)beginDate and:(NSDate *)endDate
{
    NSTimeInterval begin=[beginDate timeIntervalSince1970]*1;
    NSTimeInterval end=[endDate timeIntervalSince1970]*1;
    NSTimeInterval cha=end-begin;
    return cha;
}

//图片压缩
+ (UIImage *)scale:(UIImage *)image :(CGSize)toSize :(CGFloat)compress {
    UIGraphicsBeginImageContext(toSize);
    [image drawInRect:CGRectMake(0, 0, toSize.width, toSize.height)];
    UIImage *scaledImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *ImageData=UIImageJPEGRepresentation(scaledImage, compress);
    scaledImage=[UIImage imageWithData:ImageData];
    return scaledImage;
}

//图片大小
+ (CGSize)imgScaleSize:(CGSize)size :(CGSize)maxSize{

    CGSize scaleSize={maxSize.width,maxSize.height};
    if(size.width>maxSize.width||size.height>maxSize.height)
    {
        if(size.width<=size.height)
        {
            scaleSize.width=size.width*maxSize.height/size.height;
            scaleSize.height=maxSize.height;
        }
        else
        {
            scaleSize.height=size.height*maxSize.width/size.width;
            scaleSize.width=maxSize.width;
        }
    }
    return scaleSize;
}

//查询文件路径
+ (NSString *)queryNewFilePath :(NSString *)fileId :(NSString *)fileExtension {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];

    NSString *filePath=[cachesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileId,fileExtension]];
    return filePath;
    
}

//非空判断
+ (BOOL)isBlankString:(NSString *)string {
    if (!string || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

//生成时间戳
+(NSString *)createTimestamp {
    NSDate *datenow=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    return [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
}

//时间转时间戳
+ (NSString *)parseParamDate:(NSDate *)date {
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"\\/Date(%lld+0800)\\/", (long long)time];
}

//时间戳转时间
+ (NSDate *)getDate:(NSString *)jsonValue {
    NSRange range = [jsonValue rangeOfString:@"\\d{13}" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSString *value = [jsonValue substringWithRange:range];
    NSDate *result = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]/1000];
    return result;
}

//颜色图片
+ (UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame {
    aFrame = CGRectMake(0, 0, aFrame.size.width, aFrame.size.height);
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, aFrame);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//获取表情数组
+(NSDictionary *)getemojiDic{
    NSMutableArray *faceArray = [[ NSMutableArray alloc]init];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 60; i++) {
        [faceArray addObject:[NSString stringWithFormat:@"[express_%d]",i+1]];
        NSString* s = [NSString stringWithFormat:@"express_%d.png",i+1];
        [imageArray addObject:s];
    }
    NSArray *wk_paceImageNumArray=[imageArray copy];
    NSArray *wk_paceImageNameArray =[faceArray copy];
    
    NSDictionary *m_emojiDic = [[NSDictionary alloc] initWithObjects:wk_paceImageNumArray forKeys:wk_paceImageNameArray];
    return m_emojiDic;
}

+(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (NSDictionary *)dictionaryWithModel:(id)model {
    if (!model) {
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 获取类名/根据类名获取类对象
    NSString *className = NSStringFromClass([model class]);
    id classObject = objc_getClass([className UTF8String]);
    
    // 获取所有属性
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    // 遍历所有属性
    for (int i = 0; i < count; i++) {
        // 取得属性
        objc_property_t property = properties[i];
        // 取得属性名
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        // 取得属性值
        id propertyValue = nil;
        id valueObject = [model valueForKey:propertyName];
        
        if ([valueObject isKindOfClass:[NSDictionary class]]) {
            propertyValue = [NSDictionary dictionaryWithDictionary:valueObject];
        } else if ([valueObject isKindOfClass:[NSArray class]]) {
            propertyValue = [NSArray arrayWithArray:valueObject];
        } else if ([valueObject isKindOfClass:[NSString class]]) {
            propertyValue = [NSString stringWithFormat:@"%@", [model valueForKey:propertyName]];
        } else {
            propertyValue = [model valueForKey:propertyName];
        }
        if (!propertyValue) {
            propertyValue = @"";
        }
        
        [dict setObject:propertyValue forKey:propertyName];
    }
    return [dict copy];
}

@end
