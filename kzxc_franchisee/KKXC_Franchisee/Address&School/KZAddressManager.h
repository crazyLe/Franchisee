//
//  AddressManager.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZAddressModel.h"

typedef enum {
    KZAddressTypeProvince, //省
    KZAddressTypeCity,     //市
    KZAddressTypeCounty    //区
}KZAddressType;

@interface KZAddressManager : NSObject

//加载地址信息(第一次启动APP调用，以及每次后台更新地址库时调用，根据CheckVersion接口返回决定)
+ (void)loadAddressInfo;

/**
 获取地址模型 (省,市,区)
 1.type     : 待获取地址的类型
 2.parentId : 要查询的地址父ID 传入nil代表查询表中所有记录
 return     : 包含地址的模型数组 异常时返回nil
 */
+ (NSArray *)getAddressModelArrWithType:(KZAddressType)type parentId:(NSString *)parentId;

/**
 根据指定ID查询一条地址记录
 1.type     : 待获取地址的类型
 2.idNum    : 要查询的记录id
 */
+ (KZAddressModel *)getAddressModelWithType:(KZAddressType)type idNum:(NSString *)idNum;

/**
 获取嵌套的省份model 数组
 */
+ (NSArray <KZProvinceModel *> *)getNestedProvinceModelArr;

@end
