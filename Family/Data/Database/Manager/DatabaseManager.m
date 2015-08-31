//
//  DatabaseManager.m
//  Family
//
//  Created by jia on 15/8/13.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDatabase.h"
#import "NSObject+PropertyList.h"

@implementation DatabaseManager
+ (DatabaseManager *)sharedManager
{
    static DatabaseManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"ennew.sqlite"];
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

#pragma mark - 接口
- (BOOL)createTable:(Class)aClass
{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(%@)",NSStringFromClass(aClass).lowercaseString,[self sqlStringFromClass:aClass otherColumnNames:nil]];
    return [self executeUpdate:sql withArguments:nil];
}

//创建表，带主键
- (BOOL)createTableWithClass:(Class)aClass primaryKeyNameArray:(NSArray *)array
{
    NSString *constraintStr = [NSString stringWithFormat:@"%@ ,constraint default_constraint primary key(%@)",[self sqlStringFromClass:aClass otherColumnNames:nil], [array componentsJoinedByString:@","]];
    return [self createTableWithTableName:NSStringFromClass(aClass) detail:constraintStr];
}

- (BOOL)createTableWithClass:(Class)aClass otherColumnNames:(NSArray *)names primaryKeyNameArray:(NSArray *)array
{
    NSString *tmpStr = [NSString stringWithFormat:@"%@, constraint default_constraint primary key(%@)",[self sqlStringFromClass:aClass otherColumnNames:names],[array componentsJoinedByString:@","]];
    return [self createTableWithTableName:NSStringFromClass(aClass) detail:tmpStr];
}

- (BOOL)createTableWithTableName:(NSString *)tableName detail:(NSString *)detail
{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(%@)",tableName,detail];
    return [self executeUpdate:sql withArguments:nil];
}

//插入一条数据
- (BOOL)insertModel:(id)model
{
    NSDictionary *propertyDict = [model propertyListWithValue:YES];
    NSString *sql = [self insertSqlString:model propertyListWithValueDictionary:propertyDict];
    return [self executeUpdate:sql withArguments:[propertyDict allValues]];
}

- (BOOL)insertModel:(id)model withExtraCondition:(NSDictionary *)dict
{
    NSDictionary *propertyDict = [model propertyListWithValue:YES];
    NSMutableArray *valuesArray = [[propertyDict allValues] mutableCopy];
    [valuesArray addObjectsFromArray:[dict allValues]];
    NSString *sql = [self insertSqlString:model propertyListWithValueDictionary:propertyDict extraDictionary:dict];
    return [self executeUpdate:sql withArguments:valuesArray];
}

//像表中插入一组数据
- (BOOL)insertModelArray:(NSArray *)array
{
    __block BOOL retValue;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (id model in array) {
            NSDictionary *propertyDict = [model propertyListWithValue:YES];
            NSString *sql = [self insertSqlString:model propertyListWithValueDictionary:propertyDict];
            retValue = [db executeUpdate:sql withArgumentsInArray:[propertyDict allValues]];
            if (!retValue) {
                NSLog(@"插入数据失败1:%@",db.lastError.localizedDescription);
                *rollback = YES;
                break;
            }
        }
    }];
    return retValue;
}

//查询表中所有记录
- (NSArray *)selectAllRecord:(Class)aClass
{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",NSStringFromClass(aClass)];
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id model = [[aClass alloc] init];
            NSDictionary *dict = [rs resultDictionary];
            [model setValuesForKeysWithDictionary:dict];
            [resultArray addObject:model];
        }
        [rs close];
    }];
    return resultArray;
}

/*
 *  dict键值对为(表字段名，查询的值)
 */
- (NSArray *)selectRecordWithClass:(Class)aClass withCondition:(NSDictionary *)dict
{
    NSString *sql = @"select * from %@ ";
    NSMutableString *conditionSql = [NSMutableString string];
    NSMutableArray *conditionValueArray = [NSMutableArray array];
    
    if (dict && dict.allKeys.count) {
        [conditionSql appendString:@"where "];
        NSArray *conditionKeyArray = [dict allKeys];
        NSInteger count = conditionKeyArray.count;
        for (NSInteger i = 0; i < count; ++i) {
            NSString *key = [conditionKeyArray objectAtIndex:i];
            if (i != count - 1) {
                [conditionSql appendFormat:@"%@=? and ",key];
            } else {
                [conditionSql appendFormat:@"%@=?",key];
            }
            [conditionValueArray addObject:[dict objectForKey:key]];
        }
    }
    sql = [sql stringByAppendingString:conditionSql];
    sql = [NSString stringWithFormat:sql,NSStringFromClass(aClass)];
    return [self executeQuery:sql withArguments:conditionValueArray elementClass:aClass];
}

- (NSArray *)selectRecordWithClass:(Class)aClass withCondition:(NSDictionary *)dict orderBy:(NSString *)columnName orderOption:(BOOL)desc
{
    NSString *sql = @"select * from %@ ";
    NSString *orderSql = @"order by %@ %@";
    NSString *orderOption = desc ? @"desc " : @"asc " ;
    NSMutableString *conditionSql = [NSMutableString string];
    NSMutableArray *conditionValueArray = [NSMutableArray array];
    
    if (dict && dict.allKeys.count) {
        [conditionSql appendString:@"where "];
        NSArray *conditionKeyArray = [dict allKeys];
        NSInteger count = conditionKeyArray.count;
        for (NSInteger i = 0; i < count; ++i) {
            NSString *key = [conditionKeyArray objectAtIndex:i];
            if (i != count - 1) {
                [conditionSql appendFormat:@"%@=? and ",key];
            } else {
                [conditionSql appendFormat:@"%@=? ",key];
            }
            [conditionValueArray addObject:[dict objectForKey:key]];
        }
    }
    sql = [sql stringByAppendingString:conditionSql];
    sql = [sql stringByAppendingString:orderSql];
    sql = [NSString stringWithFormat:sql,NSStringFromClass(aClass),columnName,orderOption];
    return [self executeQuery:sql withArguments:conditionValueArray elementClass:aClass];
}

//删除表
- (BOOL)dropTableWithClass:(Class)aClass
{
    NSString *sql = [NSString stringWithFormat:@"drop table %@",NSStringFromClass(aClass)];
    __block BOOL retValue;
    [_queue inDatabase:^(FMDatabase *db) {
        retValue = [db executeUpdate:sql];
        if (!retValue) {
            NSLog(@"删除表错误:%@",db.lastError.localizedDescription);
        }
    }];
    return retValue;
}

//修改表,键值对为(字段名，值)
- (BOOL)updateTableWithClass:(Class)aClass setDict:(NSDictionary *)dict WithCondition:(NSDictionary *)conditionDict
{
    NSString *sql = @"update %@ set %@ where %@";
    NSString *setSql = [self dictionary2StrigWithComma:dict];
    NSString *conditionSql = [self dictionary2StrigWithComma:conditionDict];
    sql = [NSString stringWithFormat:sql,NSStringFromClass(aClass),setSql,conditionSql];
    __block BOOL retValue;
    [_queue inDatabase:^(FMDatabase *db) {
        retValue = [db executeUpdate:sql];
        if (!retValue) {
            NSLog(@"更新表错误:%@",db.lastError.localizedDescription);
        }
    }];
    return retValue;
}

- (BOOL)updateTableWithModel:(id)model condition:(NSDictionary *)conditionDict
{
    NSDictionary *setDict = [model propertyListWithValue:YES];
    return [self updateTableWithClass:[model class] setDict:setDict WithCondition:conditionDict];
}

- (BOOL)deleteAllRecord:(Class)aClass
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@",NSStringFromClass(aClass)];
    __block BOOL retValue;
    [_queue inDatabase:^(FMDatabase *db) {
        retValue = [db executeUpdate:sql];
        if (retValue) {
            NSLog(@"清空表记录:%@",db.lastError.localizedDescription);
        }
    }];
    return retValue;
}

- (BOOL)deleteRecordFromTable:(Class)aClass condition:(NSDictionary *)conditionDict
{
    NSString *sql = @"delete from %@ where %@";
    NSString *conditionSql = [self dictionary2StringWithAnd:conditionDict];
    sql = [NSString stringWithFormat:sql,NSStringFromClass(aClass),conditionSql];
    __block BOOL retValue;
    [_queue inDatabase:^(FMDatabase *db) {
        retValue = [db executeUpdate:sql];
        if (!retValue) {
            NSLog(@"删除记录错误:%@",db.lastError.localizedDescription);
        }
    }];
    return retValue;
}

/*  给aClass对应的表添加约束，约束让表中一直存在count条记录，根据columnName排序
 *  @param orderOption  YES时，根据columnName降序排列；NO时，根据columnName升序排列。
 */
- (BOOL)addKeepNewTriggerToTable:(Class)aClass count:(NSInteger)count orderedBy:(NSString *)columnName orderedDescend:(BOOL)orderOption
{
    NSString *tableName = NSStringFromClass(aClass);
    NSString *order = orderOption ? @"desc" : @"asc";
    NSString *sql = [NSString stringWithFormat:@"create trigger keepNew after insert on %@ \
                     begin \
                     delete from %@ where %@ not in (select %@ from %@ order by %@ %@ limit 0,%@); \
                     end",tableName ,tableName,columnName,columnName,tableName,columnName,order, [NSString stringWithFormat:@"%ld",(long)count]];
    __block BOOL retValue;
    [_queue inDatabase:^(FMDatabase *db) {
        retValue = [db executeUpdate:sql];
        if (!retValue) {
            NSLog(@"添加约束失败 ：%@",db.lastError.localizedDescription);
        }
    }];
    return retValue;
}

- (BOOL)executeUpdate:(NSString *)sql withArguments:(NSArray *)arguments
{
    __block BOOL retValue;
    [self.queue inDatabase:^(FMDatabase *db) {
        retValue = [db executeUpdate:sql withArgumentsInArray:arguments];
        if (!retValue) {
            NSLog(@"executeUpdate error:%@",db.lastError.localizedDescription);
        }
    }];
    return retValue;
}

- (NSArray *)executeQuery:(NSString *)sql withArguments:(NSArray *)arguments elementClass:(Class)aClass
{
    NSMutableArray *resultArray = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:arguments];
        while ([rs next]) {
            id model = [[aClass alloc] init];
            NSDictionary *resultDict = [rs resultDictionary];
            [model setValuesForKeysWithDictionary:resultDict];
            [resultArray addObject:model];
        }
        [rs close];
    }];
    return resultArray;
}

#pragma mark - Inner Method
- (NSString *)sqlStringFromClass:(id)model
{
    return [self sqlStringFromClass:model otherColumnNames:nil];
}

- (NSString *)sqlStringFromClass:(id)model otherColumnNames:(NSArray *)namesArray
{
    NSDictionary *propertyDict = [model propertyListWithValue:NO];
    NSArray *propertyNameArray = [propertyDict allKeys];
    NSMutableArray *tmpArr = [propertyNameArray mutableCopy];
    if (namesArray != nil && namesArray.count) {
        [tmpArr addObjectsFromArray:namesArray];
    }
    
    NSString *sql = [tmpArr componentsJoinedByString:@" text,"];
    sql = [sql stringByAppendingString:@" text"];
    return sql;
}

- (NSString *)dictionary2StrigWithComma:(NSDictionary *)dict
{
    return [self dictionary2StringWithSeparatorString:@"," dict:dict];
}

- (NSString *)dictionary2StringWithAnd:(NSDictionary *)dict
{
    return [self dictionary2StringWithSeparatorString:@" and " dict:dict];
}

- (NSString *)dictionary2StringWithSeparatorString:(NSString *)separator dict:(NSDictionary *)dict
{
    NSMutableArray *setArray = [NSMutableArray array];
    NSArray *setKeyArray = [dict allKeys];
    for (NSInteger i = 0; i < setKeyArray.count; ++i) {
        NSString *key = setKeyArray[i];
        NSString *setStr = [NSString stringWithFormat:@"%@='%@'",key,[dict objectForKey:key]];
        [setArray addObject:setStr];
    }
    return [setArray componentsJoinedByString:separator];
}

//生成这样的语句:  insert into tablename(column1,column2,column3) values(?,?,?)
- (NSString *)insertSqlString:(id)model propertyListWithValueDictionary:(NSDictionary *)propertyDict
{
    NSString *sql = @"insert into %@(%@) values(%@)";
    NSArray *propertyNameArray = [propertyDict allKeys];
    NSMutableString *valueStr = [NSMutableString string];
    NSMutableString *columnNameStr = [NSMutableString string];
    
    for (NSInteger i = 0; i < propertyNameArray.count; ++i) {
        NSString *tmpStr = [propertyNameArray objectAtIndex:i];
        [columnNameStr appendString:tmpStr];
        if (i != propertyNameArray.count - 1) {
            [valueStr appendString:@"?,"];
            [columnNameStr appendString:@","];
        } else {
            [valueStr appendString:@"?"];
        }
    }
    return  [NSString stringWithFormat:sql,NSStringFromClass([model class]),columnNameStr,valueStr];
}

/*  生成insert语句：insert into tablename(column1,column2,column3) values(?,?,?)
 *  @param  model 要插入的数据模型
 *  @param  propertyDict model的属性列表字典，键值对内容是(属性名，属性值）
 *  @param  表中存在，但model的属性不存在的字段，通过extraDictionary来指定 (字段名，值)
 */
- (NSString *)insertSqlString:(id)model propertyListWithValueDictionary:(NSDictionary *)propertyDict extraDictionary:(NSDictionary *)extraDictionary
{
    NSString *sql = @"insert into %@(%@) values(%@)";
    NSArray *propertyNameArray = [propertyDict allKeys];
    NSArray *extraPropertyNameArray = [extraDictionary allKeys];
    
    NSMutableArray *nameArray = [NSMutableArray arrayWithArray:propertyNameArray];
    [nameArray addObjectsFromArray:extraPropertyNameArray];
    NSMutableString *valueStr = [NSMutableString string];
    NSMutableString *columnNameStr = [NSMutableString string];
    
    for (NSInteger i = 0; i < nameArray.count; ++i) {
        NSString *tmpStr = [nameArray objectAtIndex:i];
        [columnNameStr appendString:tmpStr];
        if (i != nameArray.count - 1) {
            [valueStr appendString:@"?,"];
            [columnNameStr appendString:@","];
        } else {
            [valueStr appendString:@"?"];
        }
    }
    return  [NSString stringWithFormat:sql,NSStringFromClass([model class]),columnNameStr,valueStr];
}
@end
