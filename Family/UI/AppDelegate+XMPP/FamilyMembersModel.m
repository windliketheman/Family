//
//  FamilyMembersModel.m
//  ennew
//
//  Created by jzkj on 15/6/2.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "FamilyMembersModel.h"

@implementation FamilyMembersModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"userID",
                                                       @"nickname" : @"nickName"}];
}

@end

