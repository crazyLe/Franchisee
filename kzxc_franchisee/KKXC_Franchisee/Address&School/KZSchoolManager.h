//
//  KZSchoolManager.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZSchoolModel.h"

@interface KZSchoolManager : NSObject

//加载学校信息(第一次启动APP调用，以及每次后台更新学校库时调用，根据CheckVersion接口返回决定)
+ (void)loadSchoolInfo;

/**
 获取学校模型数组 根据关键字 在指定城市检索
 cityId : 要查询学校的指定地区ID
 key    : 查询的关键字,模糊搜索 如果传入nil值 则直接返回表中所有学校记录
 return : 返回模型数组
 */
+ (NSArray *)getSchollModelArrWithAreaId:(NSString *)areaId withKey:(NSString *)key;

@end
