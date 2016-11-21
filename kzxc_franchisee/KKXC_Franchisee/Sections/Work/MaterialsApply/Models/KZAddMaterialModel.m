//
//  KZAddMaterialModel.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZAddMaterialModel.h"

@implementation KZAddMaterialModel

- (id)init{
    if (self=[super init]) {
        _itemArr = [[NSMutableArray alloc] init];
        [self addItem]; //初始化默认添加一个物料项
    }
    return self;
}

/**
 添加物料项
 */
- (void)addItem{
    [_itemArr addObject:[[KZMaterialItemModel alloc] init]];
}

/**
 删除指定物料项
 */
- (void)deleteItemWithIndex:(NSUInteger)index{
    [_itemArr removeObjectAtIndex:index];
}

- (void)setDate:(NSString *)date{
    if (_date != date) {
        _date = date;
        _formaterDate = [KZDateManager dateStrWithTimeStamp:_date dateFormat:@"yyyy-MM-dd HH:mm"];
    }
}

- (NSString *)items{
    NSMutableArray *arr = [NSMutableArray array];
    for (KZMaterialItemModel *model in _itemArr) {
        if (isEmptyStr(model.name)||isEmptyStr(model.num)) {
            continue;
        }
        [arr addObject:@{@"item_id":model.item_id,@"item_num":model.num}];
    }
    return [arr mj_JSONString];
}
@end
