//
//  DatabaseManager.h
//  Family
//
//  Created by jia on 15/8/13.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface DatabaseManager : NSObject
@property (nonatomic,strong,readonly) FMDatabaseQueue *queue;
+ (DatabaseManager *)sharedManager;
//创建表
- (BOOL)createTable:(Class)aClass;
- (BOOL)createTableWithClass:(Class)aClass primaryKeyNameArray:(NSArray *)array;
- (BOOL)createTableWithClass:(Class)aClass otherColumnNames:(NSArray *)names primaryKeyNameArray:(NSArray *)array;
//插入记录
- (BOOL)insertModel:(id)model;
- (BOOL)insertModelArray:(NSArray *)array;
- (BOOL)insertModel:(id)model withExtraCondition:(NSDictionary *)dict;
//查询记录
- (NSArray *)selectAllRecord:(Class)aClass;
- (NSArray *)selectRecordWithClass:(Class)aClass withCondition:(NSDictionary *)dict;
- (NSArray *)selectRecordWithClass:(Class)aClass withCondition:(NSDictionary *)dict orderBy:(NSString *)columnName orderOption:(BOOL)desc;
//删除表
- (BOOL)dropTableWithClass:(Class)aClass;
//更新表中记录
- (BOOL)updateTableWithClass:(Class)aClass setDict:(NSDictionary *)dict WithCondition:(NSDictionary *)conditionDict;
- (BOOL)updateTableWithModel:(id)model condition:(NSDictionary *)conditionDict;
//删除记录
- (BOOL)deleteAllRecord:(Class)aClass;
- (BOOL)deleteRecordFromTable:(Class)aClass condition:(NSDictionary *)conditionDict;
//给表添加只存储最新count条记录的触发器
- (BOOL)addKeepNewTriggerToTable:(Class)aClass count:(NSInteger)count orderedBy:(NSString *)columnName orderedDescend:(BOOL)orderOption;
//fmdb update
- (BOOL)executeUpdate:(NSString *)sql withArguments:(NSArray *)arguments;

- (NSString *)sqlStringFromClass:(id)model otherColumnNames:(NSArray *)namesArray;
- (NSString *)insertSqlString:(id)model propertyListWithValueDictionary:(NSDictionary *)propertyDict;
@end
