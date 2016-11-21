//
//  KZDataBaseManager.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <FMDB.h>
#import <Foundation/Foundation.h>

@interface KZDataBaseManager : NSObject

+ (KZDataBaseManager *)shareInstance;
+(FMDatabaseQueue *)shareDatabaseQueue;//配置数据库单例队列

- (void)createTableWithName:(NSString *)tableName keyArr:(NSArray *)keyArr;//新建一个表
- (void)dropTableWithName:(NSString*)tableName;//删除一个表
- (BOOL)insertIntoTable:(NSString*)tableName Values:(id)value,...;//向一个表内插入一行
- (void)updateTable:(NSString*)tableName setDic:(NSDictionary *)dic WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;  //向一个表中插入这一行
- (void)deleteFromTable:(NSString*)tableName TargetKey:(NSString*)targetKey TargetValue:(id)targetValue;//删除一个表内的一行
- (void)updateTable:(NSString*)tableName SetTargetKey:(NSString*)targetKey WithValue:(id)targetValue WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;//更新一个表内一行的某个元素

- (id)getValueInTable:(NSString*)tableName WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue TargetKey:(NSString*)targetKey;//获取一个表内一行内容
- (NSArray*)getAllObjectsFromTable:(NSString*)table KeyArr:(NSArray*)keyArr;//获取一个表的所有内容
- (void)getAllObjectsFromTable:(NSString *)table keyArr:(NSArray*)keyArr completionBlock:(void(^)(NSArray *array))block;//获取一个表内一行内容 block回调返回(防止出现 database in use 崩溃)
- (NSArray *)getAllNOValuesInTable:(NSString*)tableName KeyArr:(NSArray *)keyArr WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;     //获取一个表中对应非key值得所有内容

- (NSArray *)getAllValuesInTable:(NSString*)tableName KeyArr:(NSArray *)keyArr WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;      //获取一个表中对应key值得所有内容

+ (id)stringToObject:(NSString*)string;

- (void)updateTable:(NSString*)tableName TargetKeys:(NSArray *)targetKeys TargetValues:(NSArray *)targetValues WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue;

//插入多条记录到数组
//tableName : 表名
//dicArr    : 字典数组
//columnArr : 要插入的列名称
- (void)insertIntoTable:(NSString*)tableName dicArr:(NSArray *)dicArr insertColumnArr:(NSArray *)columnArr;
//获取表中一条记录，以字典返回
- (NSDictionary *)getValueInTable:(NSString*)tableName WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue columnArr:(NSArray *)columnArr;
/** Indication of whether the statement is in use */
- (BOOL)isInUse;
- (void)insertIntoTableExtra:(NSString*)tableName dicArr:(NSArray *)dicArr insertColumnArr:(NSArray *)columnArr;
/**
 快速插入大数据到数据库，使用 事务操作
 1.tableName : 要插入的表名
 2.dicArr    : 要插入的字典数组  (数据源)
 3.columnArr : 准备插入的列名数组
 */
- (void)insertBigDataIntoTable:(NSString*)tableName dicArr:(NSArray *)dicArr insertColumnArr:(NSArray *)columnArr;

/**
 获取指定表里的所有记录 并以指定的model数组 返回
 1.table       : 要查询的表名
 2.keyArr      : 要查询的字段名
 3.block       : 查询完成的回调,回调返回查询的结果数组
 4.modellClass : 要转换成的model
 注:如果modelClass参数传入nil 则会以字典数组的形式返回
 */
- (void)getAllObjectsFromTable:(NSString *)table keyArr:(NSArray*)keyArr completionBlock:(void(^)(NSArray *array))block modelClass:(Class)modelClass;

/**
 从指定表中获取所有的数据，并以指定的model数组返回
 1.table    : 要获取的表名
 2.keyArr   : 要获取的列名数组
 3.modelName: 要转换成的model名称，eg. @"KZExampleModel"
 注.如果modelName参数传入nil 或者@"" 则方法将会以 字典数组的形式返回
 */
- (NSArray*)getAllObjectsFromTable:(NSString*)table KeyArr:(NSArray*)keyArr modelName:(NSString *)modelName;

/**
 获取表中一条记录，以指定的Model返回
 1.tableName   : 表名
 2.locateKey   : 定位要获取的记录的key
 3.locateValue : 定位要获取的记录的value
 4.columnArr   : 要获取的列名数组
 5.modelName   : 要传换的model 名称 eg. @"KZExampleModel"
 注.如果modelName参数传入nil 或者@"" 则方法将会以 字典数组的形式返回
 */
- (id)getObjectInTable:(NSString*)tableName WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue columnArr:(NSArray *)columnArr modelName:(NSString *)modelName;

/**
 获取满足查询条件的所有记录的model数组
 1.tableName   : 表名
 2.keyArr      : 要获取的列名
 3.locateKey   : 定位的key
 4.locateValue : 定位的value
 5.modelName   : 定位的model名称
 */
- (NSArray *)getAllObjectsInTable:(NSString*)tableName KeyArr:(NSArray *)keyArr WhereItsKey:(NSString*)locateKey IsValue:(id)locateValue modelName:(NSString *)modelName;

@end
