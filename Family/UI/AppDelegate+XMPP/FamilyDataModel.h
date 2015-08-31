//
//  FamilyDataModel.h
//  ennew
//
//  Created by mijibao on 15/5/25.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "JSONModel.h"
#import "FamilyMembersModel.h"

@protocol FamilyMembersModel @end

@interface FamilyDataModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *createDate;
@property (nonatomic, strong) NSNumber<Optional> *creater;
@property (nonatomic, strong) NSString<Optional> *descriptionInfo;
@property (nonatomic, strong) NSNumber<Optional> *familyID;
@property (nonatomic, strong) NSNumber<Optional> *familyMemberCount;
@property (nonatomic, strong) NSString<Optional> *familyName;
@property (nonatomic, strong) NSString<Optional> *pictureURL;
@property (nonatomic, strong) NSString<Optional> *groupId;

@property (nonatomic, strong) NSMutableArray<FamilyMembersModel, Optional> *membersArray;

@end
