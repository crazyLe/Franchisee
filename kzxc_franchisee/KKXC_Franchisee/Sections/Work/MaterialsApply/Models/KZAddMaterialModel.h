//
//  KZAddMaterialModel.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMaterialItemModel.h"
#import <Foundation/Foundation.h>

@interface KZAddMaterialModel : NSObject

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *date; //日期时间戳字符串

@property (nonatomic,copy) NSString *formaterDate; //格式化后的日期字符串 eg. 2016-05-05 11 : 20

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *remark;

@property (nonatomic,copy) NSString *items;

@property (nonatomic,strong) NSMutableArray <KZMaterialItemModel *> *itemArr;

/**
 添加物料项
 */
- (void)addItem;

/**
 删除指定物料项
 */
- (void)deleteItemWithIndex:(NSUInteger)index;

@end
