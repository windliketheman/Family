//
//  AddressBookCore.h
//  jinherIU
//  通讯录类
//  Created by mijibao on 14-6-17.
//  Copyright (c) 2014年 Beyondsoft. All rights reserved.

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TKAddressBook.h"

@interface AddressBookCore : NSObject

//查询通讯录
+ (NSMutableArray *)queryAddressBook;
@end
