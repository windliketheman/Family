//
//  TKAddressBook.h
//  jinherIU
//  地址本
//  Created by hoho108 on 14-5-15.
//  Copyright (c) 2014年 hoho108. All rights reserved.


#import <Foundation/Foundation.h>

@interface TKAddressBook : NSObject
@property NSInteger SectionNumber;//集合数
@property NSInteger RecordID;//记录id
@property (nonatomic, retain) NSString *Name;//名字
@property (nonatomic, retain) NSString *Email;//邮箱
@property (nonatomic, retain) NSString *Tel;//电话
@property (nonatomic,retain) UIImage *HeadImg;//头像
@end
