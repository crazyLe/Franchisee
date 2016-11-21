//
//  KZDIYWheelHeader.m
//  KKXC_Franchisee
//
//  Created by sky on 2016/10/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZDIYWheelHeader.h"

@implementation KZDIYWheelHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare {
    [super prepare];
    self.mj_h = 50;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;

    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger index = 1; index<=1; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_common_wheel_00%zd", index]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];

    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger index = 1; index<=5; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_common_wheel_00%zd", index]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];

    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
