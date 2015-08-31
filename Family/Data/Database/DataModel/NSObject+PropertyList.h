//
//  NSObject+PropertyList.h
//  Family
//
//  Created by jia on 15/8/13.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PropertyList)
- (NSDictionary *)propertyListWithValue:(BOOL)withValue;
- (NSDictionary *)propertyListWithType;
@end
