//
//  FamilyMembersModel.h
//  ennew
//
//  Created by jzkj on 15/6/2.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "JSONModel.h"

@interface FamilyMembersModel : JSONModel
@property (nonatomic, strong) NSNumber<Optional> *groupId;
@property (nonatomic, strong) NSString<Optional> *ismaster;
@property (nonatomic, strong) NSString<Optional> *nickName;
@property (nonatomic, strong) NSString<Optional> *phone;
@property (nonatomic, strong) NSString<Optional> *photo;
@property (nonatomic, strong) NSString<Optional> *settedNickName;
@property (nonatomic, strong) NSNumber<Optional> *userID;

@end

