//
//  KZMessageManager.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#define kMessageTableName @"kMessageTableName"
#define kMessageTableCollumnArr @[@"id",@"title",@"msg",@"addtime",@"isRead",@"msg_id"]

#define kMessageMaxIdKey @"kMessageMaxIdKey"
//消息最大id
#define kMessageMaxId [kUserDefault objectForKey:kMessageMaxIdKey]

#import "KZMessageManager.h"

@implementation KZMessageManager

+ (void)initialize{
    [super initialize];
    //创建表
    [[KZDataBaseManager shareInstance] createTableWithName:kMessageTableName keyArr:kMessageTableCollumnArr];
}

/**
 拉取服务器的新消息,并做本地缓存
 1.completionBlock : 完成时回调 isSuccess : 是否成功 YES==>成功 , NO==>失败
 */
+ (void)pullNewMessageWithCompletionBlock:(void(^)(BOOL isSuccess))completionBlock{
    [KZNetworkEngine postWithUrl:kPullMessageInterface paraDic:@{@"max_id":kMessageMaxId?kMessageMaxId:@"0"} successBlock:^(id jsonObj) {
        if (isEqualValue(jsonObj[@"code"], 1)) {
            //请求成功
            if ([jsonObj[@"data"] isKindOfClass:[NSArray class]] && !isEmptyArr(jsonObj[@"data"])) {
                //将消息缓存到数据库
                NSMutableArray *mutArr = [jsonObj[@"data"] mutableCopy];
                for (NSMutableDictionary *dic in mutArr) {
                    [dic setObject:@"0" forKey:kMessageTableCollumnArr[4]];
                }
                [[KZDataBaseManager shareInstance] insertIntoTable:kMessageTableName dicArr:mutArr insertColumnArr:kMessageTableCollumnArr];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //存储最大消息id ,延迟1秒读取，防止最新消息还未完全写入数据库导致读出的最大消息id不准确
                    [kUserDefault setObject:[self readMaxIdMessageModel].idNum forKey:kMessageMaxIdKey];
                    [kUserDefault synchronize];
                });
            }
            //回调
            completionBlock(YES);
        } else {
            completionBlock(NO);
        }
    } failedBlock:^(NSError *error) {
        NSLog(@"pull new message failed!");
        completionBlock(NO);
    }];
}

/**
 从数据库中读取所有的消息记录 
 return : 返回 KZMessageModel 数组
 */
+ (NSArray <KZMessageModel *> *)readAllMessageFromDB{
    NSMutableArray *elementArr = [[NSMutableArray alloc]init];
    [[KZDataBaseManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ order by id desc",kMessageTableName]];
            while ([result next])
            {
                NSMutableDictionary *elementDic = [[NSMutableDictionary alloc]init];
                for (int i=0; i<kMessageTableCollumnArr.count; i++)
                {
                    [elementDic setObject:[result stringForColumn:kMessageTableCollumnArr[i]] forKey:kMessageTableCollumnArr[i]];
                }
                [elementArr addObject:[NSClassFromString(@"KZMessageModel") mj_objectWithKeyValues:elementDic]];
            }
        }
        [db close];
    }];
    return elementArr;
//   return [[KZDataBaseManager shareInstance] getAllObjectsFromTable:kMessageTableName KeyArr:kMessageTableCollumnArr modelName:@"KZMessageModel"];
}

/**
 从消息表中读出id最大的那条消息，组装成model返回
 return : 返回最大id的消息model
 */
+ (KZMessageModel *)readMaxIdMessageModel{
    KZMessageModel *model = [[KZMessageModel alloc] init];
    [[KZDataBaseManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"select * from %@ order by id desc limit 1",kMessageTableName];
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                model.idNum = [set stringForColumn:kMessageTableCollumnArr[0]];
                model.title = [set stringForColumn:kMessageTableCollumnArr[1]];
                model.msg = [set stringForColumn:kMessageTableCollumnArr[2]];
                model.addtime = [set stringForColumn:kMessageTableCollumnArr[3]];
                model.isRead = [set stringForColumn:kMessageTableCollumnArr[4]];
            }
        }
        [db close];
    }];
    return model;
}

/**
 设置某条消息已读
 1.model : 要设置已读的消息model
 */
+ (void)setMessageAlreadyRead:(KZMessageModel *)model{
    [[KZDataBaseManager shareInstance] updateTable:kMessageTableName SetTargetKey:kMessageTableCollumnArr[4] WithValue:@"1" WhereItsKey:@"id" IsValue:model.idNum];
}

/**
 删除某条消息
 1.model 要删除的消息model
 */
+ (void)deleteMessage:(KZMessageModel *)model{
    [[KZDataBaseManager shareInstance] deleteFromTable:kMessageTableName TargetKey:@"id" TargetValue:model.idNum];
}

/**
 查询所有未读消息
 return : 返回消息表中所有的未读消息model数组
 */
+ (NSArray *)queryAllUnReadMessage{
  return [[KZDataBaseManager shareInstance] getAllObjectsInTable:kMessageTableName KeyArr:kMessageTableCollumnArr WhereItsKey:@"isRead" IsValue:@"0" modelName:@"KZMessageModel"];
}

@end
