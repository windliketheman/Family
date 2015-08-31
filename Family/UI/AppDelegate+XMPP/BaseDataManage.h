//
//  BaseDataManage.h
//  jinherIU
//  数据库操作基类
//  Created by mijibao on 14-9-18.
//  Copyright (c) 2014年 hoho108. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface BaseDataManage : NSObject

+ (instancetype)instance;
+ (FMDatabaseQueue *)sharedQueue;

@end
