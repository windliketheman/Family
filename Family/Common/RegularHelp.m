//
//  RegularHelp.m
//  ennew
//  正则匹配类
//  Created by jzkj on 15/7/20.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "RegularHelp.h"

@implementation RegularHelp

+ (BOOL) validateUserPhone:(NSString *)str
{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^1[3|4|5|7|8][0-9][0-9]{8}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

@end
