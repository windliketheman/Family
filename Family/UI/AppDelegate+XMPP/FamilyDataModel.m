//
//  FamilyDataModel.m
//  ennew
//
//  Created by mijibao on 15/5/25.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "FamilyDataModel.h"

@implementation FamilyDataModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"familyID",
                                                       @"members" : @"membersArray"}];
}

@end

