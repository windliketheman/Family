//
//  NSObject+PropertyList.m
//  Family
//
//  Created by jia on 15/8/13.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "NSObject+PropertyList.h"
#import <objc/runtime.h>

@implementation NSObject (PropertyList)
- (NSDictionary *)propertyListWithValue:(BOOL)withValue
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    u_int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (u_int i = 0; i < count; ++i) {
        NSString *propertyName = [NSString stringWithCString:property_getName(propertyList[i]) encoding:NSUTF8StringEncoding];
        if (withValue) {
            id propertyValue = [self valueForKey:propertyName];
            if (propertyName) {
                if (propertyValue == nil) {
                    [resultDict setObject:[NSNull null] forKey:propertyName];
                } else {
                    [resultDict setObject:propertyValue forKey:propertyName];
                }
            }
        } else {
            [resultDict setObject:[NSNull null] forKey:propertyName];
        }
    }
    return resultDict;
}

//键值对(propertyName,propertyType)
- (NSDictionary *)propertyListWithType
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    u_int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (u_int i = 0; i < count; ++i) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *propertyType = [self typeOfProperty:property];
        [resultDict setObject:propertyType forKey:propertyName];
    }
    return resultDict;
}

#pragma mark - Inner Method
- (NSString *)typeOfProperty:(objc_property_t)property
{
    NSString *propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    if ([propertyAttribute hasPrefix:@"T@,"]) {
        return @"id";
    }
    if ([propertyAttribute hasPrefix:@"T@"]) {
        NSRange range = [propertyAttribute rangeOfString:@"\"" options:NSBackwardsSearch];
        NSRange typeStringRange = NSMakeRange(3, range.location - 3);
        return [propertyAttribute substringWithRange:typeStringRange];
    } else if ([propertyAttribute hasPrefix:@"T#"]) {
        return @"Class";
    } else {
        NSString *tmpStr = [propertyAttribute substringWithRange:NSMakeRange(1, 1)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"typeEncoding" ofType:@"plist"];
        if (path) {
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            return [dict objectForKey:tmpStr];
        }
    }
    return nil;
}
@end
