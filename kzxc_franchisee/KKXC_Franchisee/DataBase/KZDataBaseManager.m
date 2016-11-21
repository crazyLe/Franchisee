//
//  KZDataBaseManager.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZDataBaseManager.h"

@implementation KZDataBaseManager
{
    FMDatabase *_db;
    FMStatement *fm_state;
}

+ (KZDataBaseManager*)shareInstance;
{
    static KZDataBaseManager *manager;
    if (manager==nil)
    {
        manager = [[KZDataBaseManager alloc]init];
    }
    return manager;
}

#pragma mark - 配置数据库单例队列
+(FMDatabaseQueue *)shareDatabaseQueue
{
    static FMDatabaseQueue *my_FMDatabaseQueue=nil;
    
    if (!my_FMDatabaseQueue) {
        NSString *path = nil;
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DataBase.db"];
        my_FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return my_FMDatabaseQueue;
}

- (instancetype)init;
{
    self = [super init];
    if (self)
    {
        NSString *path = nil;
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DataBase.db"];
        _db = [[FMDatabase alloc]initWithPath:path];
        fm_state = [[FMStatement alloc] init];
    }
    return self;
}

- (void)createTableWithName:(NSString *)tableName keyArr:(NSArray *)keyArr;
{
    FMDatabaseQueue *queue = [KZDataBaseManager shareDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSMutableString *commandStr = [[NSMutableString alloc]initWithFormat:@"create table if not exists %@",tableName];
            for (int i=0; i<keyArr.count; i++)
            {
                if (i==0)
                {
                    [commandStr appendFormat:@"(%@ primary key",keyArr[i]];
                    if (keyArr.count==1)
                    {
                        [commandStr appendFormat:@")"];
                    }
                }
                else if (i!=keyArr.count-1)
                {
                    [commandStr appendFormat:@",%@",keyArr[i]];
                }
                else
                {
                    [commandStr appendFormat:@",%@)",keyArr[i]];
                }
            }
            if ([db executeUpdate:commandStr])
            {
                NSLog(@"%@",[NSString stringWithFormat:@"create table %@ success!",tableName]);
            }
            else
            {
                NSLog(@"%@",[NSString stringWithFormat:@"create table %@ failed!",tableName]);
            }
            [db close];
        }
        else
        {
            NSLog(@"数据库打开失败!");
        }
    }];
}

- (void)dropTableWithName:(NSString*)tableName;
{
    [_db open];
    if ([_db executeUpdate:[NSString stringWithFormat:@"drop table %@",tableName]])
    {
        NSLog(@"%@",[NSString stringWithFormat:@"drop table %@ success!",tableName]);
    }
    else
    {
        NSLog(@"%@",[NSString stringWithFormat:@"drop table %@ failed!",tableName]);
    }
    [_db close];
}

- (BOOL)insertIntoTable:(NSString*)tableName Values:(id)value,...;
{
    [_db open];
    
    NSMutableString *commandStr = [[NSMutableString alloc]initWithFormat:@"insert into %@ values ",tableName];
    va_list list;
    NSMutableArray *valueArr = [[NSMutableArray alloc]init];
    if (value)
    {
        va_start(list, value);
        NSString *curStr = value;
        do
        {
            if (([curStr isKindOfClass:[NSNull class]])||(curStr==nil))
            {
                break;
            }
            else
            {
                if ([curStr isKindOfClass:[NSDictionary class]]||[curStr isKindOfClass:[NSArray class]])
                {
                    curStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:curStr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                }
                else
                {
                    curStr = [NSString stringWithFormat:@"%@",curStr];
                }
                [valueArr addObject:curStr];
            }
        }while ((curStr = va_arg(list, id)));
        va_end(list);
    }
    
    for (int i=0; i<valueArr.count; i++)
    {
        if (i==0)
        {
            [commandStr appendString:@"(?"];
            if (valueArr.count==1)
            {
                [commandStr appendString:@")"];
            }
        }
        else if (i==valueArr.count-1)
        {
            [commandStr appendString:@",?)"];
        }
        else
        {
            [commandStr appendString:@",?"];
        }
    }
    
    if (![_db executeUpdate:commandStr withArgumentsInArray:valueArr])
    {
        NSLog(@"insert failed!");
        [_db close];
        return NO;
    }
    else
    {
        NSLog(@"insert success!");
        [_db close];
        return YES;
    }
}


//插入多条记录到数组
//tableName : 表名
//dicArr    : 字典数组
//columnArr : 要插入的列名称
- (void)insertIntoTable:(NSString*)tableName dicArr:(NSArray *)dicArr insertColumnArr:(NSArray *)columnArr
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block BOOL isSuccess = YES;
        NSMutableString *sql =  [[NSMutableString alloc]initWithFormat:@"insert into %@ values ",tableName];
        NSDictionary *dic = [dicArr firstObject];
        for (int i = 0; i < dic.count ; i++) {
            if (i==0)
            {
                [sql appendString:@"(?"];
                if (dic.count==1)
                {
                    [sql appendString:@")"];
                }
            }
            else if (i==dic.count-1)
            {
                [sql appendString:@",?)"];
            }
            else
            {
                [sql appendString:@",?"];
            }
        }
        
        NSMutableArray *valueArr = nil;
        
        int i = 0;
        
        for (NSDictionary *dic in dicArr) {
            
            valueArr = [NSMutableArray array];
            
            for (NSString *columnName in columnArr) {
                
                NSString *curStr = dic[columnName];
                
                if ([curStr isKindOfClass:[NSDictionary class]]||[curStr isKindOfClass:[NSArray class]])
                {
                    curStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:curStr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                }
                else
                {
                    curStr = [NSString stringWithFormat:@"%@",curStr];
                }
                
                [valueArr addObject:curStr];
            }
            
            [[KZDataBaseManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
                //                NSLog(@"thread ==> %d",[[NSThread currentThread ] isMainThread]);
                if ([db open]) {
                    
                    if (![db executeUpdate:sql withArgumentsInArray:valueArr])
                    {
                        NSLog(@"insert failed!");
                        isSuccess = NO;
                    }
                    else
                    {
                        //                    NSLog(@"insert success!");
                    }
                    
                    [db close];
                }
                else
                {
                    
                }
            }];
            
            i++;
        }
    });
}

- (void)insertIntoTableExtra:(NSString*)tableName dicArr:(NSArray *)dicArr insertColumnArr:(NSArray *)columnArr
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableString *sql =  [[NSMutableString alloc]initWithFormat:@"insert into %@ values ",tableName];
        
        NSDictionary *dic = dicArr[0];
        NSArray *dicKey = dic.allKeys;
        for (int i = 0; i < dicArr.count; i++) {
            for (int j = 0 ; j < dicKey.count ; j++) {
                NSString *str = dicArr[i][columnArr[j]];
                if (j==0)
                {
                    [sql appendString:[NSString stringWithFormat:@"(%@",str]];
                    if (dic.count==1)
                    {
                        [sql appendString:@")"];
                    }
                }
                else if (j==dic.count-1)
                {
                    [sql appendString:[NSString stringWithFormat:@",%@)",str]];
                }
                else
                {
                    [sql appendString:[NSString stringWithFormat:@",%@",str]];
                }
            }
            if (i!=dicArr.count-1) {
                [sql appendString:@","];
            }
        }
        
        [[KZDataBaseManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
            //                NSLog(@"thread ==> %d",[[NSThread currentThread ] isMainThread]);
            if ([db open]) {
                
                if (![db executeUpdate:sql])
                {
                    NSLog(@"insert failed!");
                }
                else
                {
                    //                    NSLog(@"insert success!");
                }
                
                [db close];
            }
            else
            {
                
            }
        }];
        
        NSLog(@"sql==>%@",sql);
    });
    
}

/**
 快速插入大数据到数据库，使用 事务操作
 1.tableName : 要插入的表名
 2.dicArr    : 要插入的字典数组  (数据源)
 3.columnArr : 准备插入的列名数组
 */
- (void)insertBigDataIntoTable:(NSString*)tableName dicArr:(NSArray *)dicArr insertColumnArr:(NSArray *)columnArr
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[KZDataBaseManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
            NSLog(@"BeginInsert--------->");
            if ([db open] == NO)
            {
                [db close];
                return;
            }
            [db beginTransaction];  //开始事务
            BOOL isExcpetion = NO; //标志有没有抛出异常
            @try {
                __block BOOL isSuccess = YES;
                NSMutableString *sql =  [[NSMutableString alloc]initWithFormat:@"insert into %@ values ",tableName];
                NSDictionary *dic = [dicArr firstObject];
                for (int i = 0; i < dic.count ; i++) {
                    if (i==0)
                    {
                        [sql appendString:@"(?"];
                        if (dic.count==1)
                        {
                            [sql appendString:@")"];
                        }
                    }
                    else if (i==dic.count-1)
                    {
                        [sql appendString:@",?)"];
                    }
                    else
                    {
                        [sql appendString:@",?"];
                    }
                }
                
                NSMutableArray *valueArr = nil;
                
                int i = 0;
                
                for (NSDictionary *dic in dicArr) {
                    
                    valueArr = [NSMutableArray array];
                    
                    for (NSString *columnName in columnArr) {
                        
                        NSString *curStr = dic[columnName];
                        
                        if ([curStr isKindOfClass:[NSDictionary class]]||[curStr isKindOfClass:[NSArray class]])
                        {
                            curStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:curStr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                        }
                        else
                        {
                            curStr = [NSString stringWithFormat:@"%@",curStr];
                        }
                        
                        [valueArr addObject:curStr];
                    }
                    if (![db executeUpdate:sql withArgumentsInArray:valueArr])
                    {
                        NSLog(@"insert failed!");
                        isSuccess = NO;
                    }
                    else
                    {
                        //                  NSLog(@"insert success!");
                    }
                    
                    i++;
                }
            }
            @catch (NSException *exception)
            {
                [db rollback]; //回滚数据库到插入之前的状态
                isExcpetion = YES; //标示出现异常
                NSLog(@"exception when insert into DB Table");
            }
            @finally
            {
                if (!isExcpetion) {
                    [db commit]; //未出现异常，则提交事务
                }
            }
            [db close]; //关闭数据库
            NSLog(@"EndInsert--------->");
        }];
    });
}

- (void)updateTable:(NSString*)tableName setDic:(NSDictionary *)dic WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [_db open];
    
    NSMutableArray *setArr = [NSMutableArray array];
    for (NSString *key in dic) {
        [setArr addObject:[NSString stringWithFormat:@"%@=%@",key,dic[key]]];
    }
    
    NSString *setStr = [setArr componentsJoinedByString:@","];
    
    if (![_db executeUpdate:[NSString stringWithFormat:@"update %@ set %@ where %@ = ?",tableName,setStr,locateKey],locateValue])
    {
        NSLog(@"update failed!");
    }
    else
    {
        NSLog(@"update success!");
    }
    [_db close];
}

- (void)deleteFromTable:(NSString*)tableName TargetKey:(NSString*)targetKey TargetValue:(id)targetValue;
{
    [_db open];
    if (([targetValue isKindOfClass:[NSNull class]])||(targetValue==nil))
    {
        return;
    }
    else
    {
        if (![targetValue isKindOfClass:[NSString class]])
        {
            targetValue = [NSString stringWithFormat:@"%@",targetValue];
        }
    }
    if (![_db executeUpdate:[NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName,targetKey,targetValue]])
    {
        NSLog(@"delete failed!");
    }
    else
    {
        NSLog(@"delete success!");
    }
    [_db close];
}

- (void)updateTable:(NSString*)tableName SetTargetKey:(NSString*)targetKey WithValue:(id)targetValue WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [_db open];
    if ([targetValue isKindOfClass:[NSDictionary class]]||[targetValue isKindOfClass:[NSArray class]])
    {
        targetValue = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:targetValue options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
    NSString *str = [NSString stringWithFormat:@"update %@ set %@ = '%@' where %@ = '%@'",tableName,targetKey,targetValue,locateKey,locateValue];
    if (![_db executeUpdate:str])
    {
        NSLog(@"update failed!");
    }else{
        NSLog(@"update success!");
    }
    [_db close];
}

- (void)updateTable:(NSString*)tableName TargetKeys:(NSArray *)targetKeys TargetValues:(NSArray *)targetValues WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [_db open];
    
    if (!targetKeys || !targetValues || !locateKey || !locateValue) {
        NSLog(@"参数有空值!");
        return;
    }
    
    if (targetKeys.count != targetValues.count) {
        NSLog(@"key和value个数不匹配!");
        return;
    }
    
    NSMutableArray *setArr = [NSMutableArray array];
    int i = 0;
    for (NSString *key in targetKeys) {
        NSString *value = targetValues[i];
        [setArr addObject:[NSString stringWithFormat:@"%@='%@'",key,value]];
        i++;
    }
    
    NSString *setStr = [setArr componentsJoinedByString:@","];
    
    if (![_db executeUpdate:[NSString stringWithFormat:@"update %@ set %@ where %@ = ?",tableName,setStr,locateKey],locateValue])
    {
        NSLog(@"update failed!");
    }
    else
    {
        NSLog(@"update success!");
    }
    [_db close];
}


- (id)getValueInTable:(NSString*)tableName WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue TargetKey:(NSString*)targetKey;
{
    [_db open];
    if (![locateValue isKindOfClass:[NSString class]])
    {
        locateValue = [locateValue stringValue];
    }
    FMResultSet *result = [_db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?",tableName,locateKey],locateValue];
    id targetValue;
    while ([result next])
    {
        targetValue = [result stringForColumn:targetKey];
    }
    [result close];
    [_db close];
    return targetValue;
}

//获取表中一条记录，以字典返回
- (NSDictionary *)getValueInTable:(NSString*)tableName WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue columnArr:(NSArray *)columnArr;
{
    [_db open];
    if (![locateValue isKindOfClass:[NSString class]])
    {
        locateValue = [locateValue stringValue];
    }
    FMResultSet *result = [_db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?",tableName,locateKey],locateValue];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    while ([result next])
    {
        for (int i = 0; i < columnArr.count; i++) {
            [dic setObject:[result stringForColumn:columnArr[i]] forKey:columnArr[i]];
        }
    }
    [result close];
    [_db close];
    return dic;
}

/**
 获取表中一条记录，以指定的Model返回
 1.tableName   : 表名
 2.locateKey   : 定位要获取的记录的key
 3.locateValue : 定位要获取的记录的value
 4.columnArr   : 要获取的列名数组
 5.modelName   : 要传换的model 名称 eg. @"KZExampleModel"
 注.如果modelName参数传入nil 或者@"" 则方法将会以 字典数组的形式返回
 */
- (id)getObjectInTable:(NSString*)tableName WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue columnArr:(NSArray *)columnArr modelName:(NSString *)modelName
{
    if (isEmptyStr(modelName)) {
        return [self getValueInTable:tableName WhereItsKey:locateKey IsValue:locateValue columnArr:columnArr];
    } else {
        return [NSClassFromString(modelName) mj_objectWithKeyValues:[self getValueInTable:tableName WhereItsKey:locateKey IsValue:locateValue columnArr:columnArr]];
    }
}

- (NSArray *)getAllValuesInTable:(NSString*)tableName KeyArr:(NSArray *)keyArr WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [_db open];
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    if (![locateValue isKindOfClass:[NSString class]])
    {
        locateValue = [locateValue stringValue];
    }
    FMResultSet *result = [_db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?",tableName,locateKey],locateValue];
    while ([result next])
    {
        NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
        for (int i=0; i<keyArr.count; i++)
        {
            [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
        }
        [elementArr addObject:elementDic];
    }
    [_db close];
    return elementArr;
}

/**
 获取满足查询条件的所有记录的model数组
 1.tableName   : 表名
 2.keyArr      : 要获取的列名
 3.locateKey   : 定位的key
 4.locateValue : 定位的value
 5.modelName   : 定位的model名称
 */
- (NSArray *)getAllObjectsInTable:(NSString*)tableName KeyArr:(NSArray *)keyArr WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue modelName:(NSString *)modelName{
    
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    [[KZDataBaseManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?",tableName,locateKey],locateValue];
            while ([result next])
            {
                NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
                for (int i=0; i<keyArr.count; i++)
                {
                    [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
                }
                [elementArr addObject:[NSClassFromString(modelName) mj_objectWithKeyValues:elementDic]];
            }
        }
        [db close];
    }];
    return elementArr;
}

- (NSArray *)getAllNOValuesInTable:(NSString*)tableName KeyArr:(NSArray *)keyArr WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;
{
    [_db open];
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    if (![locateValue isKindOfClass:[NSString class]])
    {
        locateValue = [locateValue stringValue];
    }
    FMResultSet *result = [_db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ != ?",tableName,locateKey],locateValue];
    while ([result next])
    {
        NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
        for (int i=0; i<keyArr.count; i++)
        {
            [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
        }
        [elementArr addObject:elementDic];
    }
    [_db close];
    return elementArr;
}

- (NSArray*)getAllObjectsFromTable:(NSString*)table KeyArr:(NSArray*)keyArr;
{
    [_db open];
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    FMResultSet *result = [_db executeQuery:[NSString stringWithFormat:@"select * from %@",table]];
    while ([result next])
    {
        NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
        for (int i=0; i<keyArr.count; i++)
        {
            [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
        }
        [elementArr addObject:elementDic];
    }
    [_db close];
    return elementArr;
}

/**
 从指定表中获取所有的数据，并以指定的model数组返回
 1.table    : 要获取的表名
 2.keyArr   : 要获取的列名数组
 3.modelName: 要转换成的model名称，eg. @"KZExampleModel" 
 注.如果modelName参数传入nil 或者@"" 则方法将会以 字典数组的形式返回
 */
- (NSArray*)getAllObjectsFromTable:(NSString*)table KeyArr:(NSArray*)keyArr modelName:(NSString *)modelName
{
    if (isEmptyStr(modelName)) {
        return [self getAllObjectsFromTable:table KeyArr:keyArr];
    } else {
        [_db open];
        NSMutableArray *elementArr = [[NSMutableArray alloc]init];
        FMResultSet *result = [_db executeQuery:[NSString stringWithFormat:@"select * from %@",table]];
        while ([result next])
        {
            NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
            for (int i=0; i<keyArr.count; i++)
            {
                [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
            }
            [elementArr addObject:[NSClassFromString(modelName) mj_objectWithKeyValues:elementDic]];
        }
        [_db close];
        return elementArr;
    }
}

- (void)getAllObjectsFromTable:(NSString *)table keyArr:(NSArray*)keyArr completionBlock:(void(^)(NSArray *array))block
{
    [[KZDataBaseManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSMutableArray *elementArr = [[NSMutableArray alloc]init];
            FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@",table]];
            while ([result next])
            {
                NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
                for (int i=0; i<keyArr.count; i++)
                {
                    [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
                }
                [elementArr addObject:elementDic];
            }
            [db close];
            block(elementArr);
        }
        else
        {
            NSLog(@"database open failed!");
        }
    }];
}

/**
 获取指定表里的所有记录 并以指定的model数组 返回  
 1.table       : 要查询的表名
 2.keyArr      : 要查询的字段名
 3.block       : 查询完成的回调,回调返回查询的结果数组
 4.modellClass : 要转换成的model 
    注:如果modelClass参数传入nil 则会以字典数组的形式返回
 */
- (void)getAllObjectsFromTable:(NSString *)table keyArr:(NSArray*)keyArr completionBlock:(void(^)(NSArray *array))block modelClass:(Class)modelClass
{
    if (modelClass) {
        [[KZDataBaseManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                NSMutableArray *elementArr = [[NSMutableArray alloc]init];
                FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@",table]];
                while ([result next])
                {
                    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
                    for (int i=0; i<keyArr.count; i++)
                    {
                        [elementDic setObject:[result stringForColumn:keyArr[i]] forKey:keyArr[i]];
                    }
                    id aModel = [modelClass mj_objectWithKeyValues:elementDic];
                    [elementArr addObject:aModel];
                }
                [db close];
                block(elementArr);
            }
            else
            {
                NSLog(@"database open failed!");
            }
        }];
    } else {
        [self getAllObjectsFromTable:table keyArr:keyArr completionBlock:block];
    }
}

+ (id)stringToObject:(NSString*)string;
{
    if (string==nil)
    {
        string = @"";
    }
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

/** Indication of whether the statement is in use */
- (BOOL)isInUse
{
    return fm_state.inUse;
}

@end
