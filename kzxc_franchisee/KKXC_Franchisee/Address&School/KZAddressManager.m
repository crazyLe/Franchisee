//
//  AddressManager.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#define kTabelNameArr    @[kProvinceTableName,kCityTableName,kCountyTableName]
#define kTableCollumnArr @[kProvinceTableCollumnArr,kCityTableColumnArr,kCountyTableCollumnArr]
#define kIsCacheDataArr  @[cacheProvinceDataKey,cacheCityDataKey,cacheCountyDataKey]

#import "KZAddressManager.h"

@implementation KZAddressManager

+ (void)loadAddressInfo{
    //加载 省 市 区,缓存到本地数据库
    for (int i = 1; i < 4; i++) {
        [KZAddressManager loadAddressWithLevelId:i];
    }
}

//加载城市通过LevelId
+ (void)loadAddressWithLevelId:(int)levelId{
    
    NSArray *tableNameArr = kTabelNameArr; //省,市,县
    NSArray *tableCollumnArr = kTableCollumnArr;
    NSArray *isCacheDataArr = kIsCacheDataArr;
    
    NSDictionary *paraDic = @{@"level_id":@(levelId)};
    [KZNetworkEngine postWithUrl:kGetAddressInfoInterface paraDic:paraDic successBlock:^(id jsonObj) {
        if (isEqualValue(jsonObj[@"code"], 1)) {
            
            NSArray *arr1 = jsonObj[@"data"];
            
            if (arr1.count>0) {
                
                KZDataBaseManager *db_manager = [KZDataBaseManager shareInstance];
                
                if ([[kUserDefault objectForKey:isCacheDataArr[levelId-1]] boolValue]) {
                    //如果已经缓存了对应的数据,则先删除之前创建的表，以清空数据再更新地址库
                    [db_manager dropTableWithName:tableNameArr[levelId-1]];
                    [kUserDefault setBool:NO forKey:isCacheDataArr[levelId-1]];
                }
                
                //创建表
                [db_manager createTableWithName:tableNameArr[levelId-1] keyArr:tableCollumnArr[levelId-1]];
                
                //插入数据到数据库
                [db_manager insertBigDataIntoTable:tableNameArr[levelId-1] dicArr:arr1 insertColumnArr:tableCollumnArr[levelId-1]];
                
                //记录 并 立即同步写入
                [kUserDefault setBool:YES forKey:isCacheDataArr[levelId-1]]; //记录已经缓存了县数据
                [kUserDefault synchronize];
                
                if (levelId==2) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self prepareNestedAddressModel];
                    });
                }
            }
            
        }
    } failedBlock:^(NSError *error) {
        NSLog(@"load address information failed!");
    }];
}

/**
 准备嵌套的地址model,省嵌套市model 做二级联动
 */
+ (void)prepareNestedAddressModel{
    //1.获取数据库中所有省
    NSArray *provinceModelArr = [self getAddressModelArrWithType:KZAddressTypeProvince parentId:0];
    NSMutableArray *retProvinceModelArr = [NSMutableArray array];
    //2.遍历所有省
    for (KZAddressModel *model in provinceModelArr) {
        //3.以model中的省id去检索市数据库表中的所拥有的所有的市
        NSArray *cityModelArr = [self getAddressModelArrWithType:KZAddressTypeCity parentId:model.idNum];
        KZProvinceModel *provinceModel = [[KZProvinceModel alloc] init];
        provinceModel.cityModelArr = cityModelArr;
        provinceModel.idNum = model.idNum;
        provinceModel.parentId = model.parentId;
        provinceModel.levelId = model.levelId;
        provinceModel.areaName = model.areaName;
        provinceModel.areaPhonetic = model.areaPhonetic;
        provinceModel.areaShortName = model.areaShortName;
        provinceModel.isHot = model.isHot;
        provinceModel.latitude = model.latitude;
        provinceModel.longitude = model.longitude;
        [retProvinceModelArr addObject:provinceModel];
    }
    //4.转换成NSData
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:retProvinceModelArr];
    [kUserDefault setObject:data forKey:@"provinceModelArr"];
}

/**
 获取嵌套的省份model 数组
 */
+ (NSArray <KZProvinceModel *> *)getNestedProvinceModelArr{
    NSData *data = [kUserDefault objectForKey:@"provinceModelArr"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return arr;
}

/**
 获取地址模型 (省,市,区)
 1.type     : 待获取地址的类型
 2.parentId : 要查询的地址父ID 传入nil代表查询表中所有记录
 return     : 包含地址的模型数组 异常时返回nil
 */
+ (NSArray *)getAddressModelArrWithType:(KZAddressType)type parentId:(NSString *)parentId{
    if (!parentId) {
        //查询表中所有记录
        NSArray *arr = type==KZAddressTypeProvince?kProvinceDicArr:type==KZAddressTypeCity?kCityDicArr:type==KZAddressTypeCounty?kCountryDicArr:nil;
        if (!isEmptyArr(arr)) {
            return [KZAddressModel mj_objectArrayWithKeyValuesArray:arr];
        } else {
            NSLog(@"Get Address Model Array Failed! check the type is correct,then check the database is already have the province/city/county data.");
            return nil;
        }
    } else {
        //查询指定父ID的地址记录
        NSArray *tableNameArr = kTabelNameArr; //省,市,县
        NSArray *tableCollumnArr = kTableCollumnArr;
        NSArray *dicArr = [[KZDataBaseManager shareInstance] getAllValuesInTable:tableNameArr[type] KeyArr:tableCollumnArr[type] WhereItsKey:@"parentId" IsValue:parentId];
        if (!isEmptyArr(dicArr)) {
            return [KZAddressModel mj_objectArrayWithKeyValuesArray:dicArr];
        } else {
            return nil;
        }
    }
}

/**
 根据指定ID查询一条地址记录
 1.type     : 待获取地址的类型
 2.idNum    : 要查询的记录id
 */
+ (KZAddressModel *)getAddressModelWithType:(KZAddressType)type idNum:(NSString *)idNum{
    if (isEmptyStr(idNum)) {
        NSLog(@"plase set invoke  get address model with id");
        return nil;
    } else {
        //根据ID查询指定的地址记录
        NSArray *tableNameArr = kTabelNameArr; //省,市,县
        NSArray *tableCollumnArr = kTableCollumnArr;
        NSDictionary *dic = [[KZDataBaseManager shareInstance] getValueInTable:tableNameArr[type] WhereItsKey:@"id" IsValue:idNum columnArr:tableCollumnArr[type]];
        KZAddressModel *model = [KZAddressModel mj_objectWithKeyValues:dic];
        return model;
    }
}


@end
