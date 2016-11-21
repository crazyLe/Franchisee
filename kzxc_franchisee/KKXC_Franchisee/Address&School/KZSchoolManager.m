//
//  KZSchoolManager.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZSchoolManager.h"

@implementation KZSchoolManager

+ (void)loadSchoolInfo{
    NSDictionary *paraDic = @{@"area_id":@(0)};
    [KZNetworkEngine postWithUrl:kGetSchoolInfoInterface paraDic:paraDic successBlock:^(id jsonObj) {
        if (isEqualValue(jsonObj[@"code"], 1)) {
            
            NSArray *arr1 = jsonObj[@"data"];
            
            if (arr1.count>0) {
                
                KZDataBaseManager *db_manager = [KZDataBaseManager shareInstance];
                
                if ([[kUserDefault objectForKey:cacheSchoolDataKey] boolValue]) {
                    //如果已经缓存了对应的数据,则先删除之前创建的表，以清空数据再更新地址库
                    [db_manager dropTableWithName:kSchoolTableName];
                    [kUserDefault setBool:NO forKey:cacheSchoolDataKey];
                }
                
                //创建表
                [db_manager createTableWithName:kSchoolTableName keyArr:kSchoolTableCollumnArr];
                
                //插入数据到数据库
                [db_manager insertBigDataIntoTable:kSchoolTableName dicArr:arr1 insertColumnArr:kSchoolTableCollumnArr];
                
                //记录 并 立即同步写入
                [kUserDefault setBool:YES forKey:cacheSchoolDataKey]; //记录已经缓存了县数据
                [kUserDefault synchronize];
                
            }
            
        }
    } failedBlock:^(NSError *error) {
        NSLog(@"load school information failed!");
    }];
}

/**
 获取学校模型数组 根据关键字 在指定城市检索
 cityId : 要查询学校的指定地区ID
 key    : 查询的关键字,模糊搜索 如果传入nil值 则直接返回表中所有学校记录
 return : 返回模型数组
 */
+ (NSArray *)getSchollModelArrWithAreaId:(NSString *)areaId withKey:(NSString *)key{
    if (!key) {
        NSArray *arr = kSchoolDicArr;
        if (!isEmptyArr(arr)) {
            return [KZSchoolModel mj_objectArrayWithKeyValuesArray:arr];
        } else {
            return nil;
        }
    } else {
        //去除key中空格
       NSArray *keyArr = [key componentsSeparatedByString:@" "];
        key = [keyArr componentsJoinedByString:@""];
       NSArray *dicArr =  [[KZDataBaseManager shareInstance] getAllValuesInTable:kSchoolTableName KeyArr:kSchoolTableCollumnArr WhereItsKey:@"areaId" IsValue:areaId];
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSDictionary *dic in dicArr) {
            if ([dic[@"schoolName"] rangeOfString:key].location != NSNotFound) {
                [modelArr addObject:[KZSchoolModel mj_objectWithKeyValues:dic]];
            }
        }
        if (!isEmptyArr(modelArr)) {
            return modelArr;
        } else {
            return nil;
        }
    }
}

/*
 json===>
{
    code = 1;
    data =     (
                {
                    areaId = 340100;
                    id = 1;
                    schoolName = "\U4e2d\U56fd\U79d1\U5b66\U6280\U672f\U5927\U5b66";
                },
                {
                    areaId = 340100;
                    id = 2;
                    schoolName = "\U5b89\U5fbd\U5927\U5b66";
                }
    msg = "";
}
*/

@end
