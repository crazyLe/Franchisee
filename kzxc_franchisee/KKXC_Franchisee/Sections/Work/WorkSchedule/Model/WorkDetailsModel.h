//
//  WorkDetailsModel.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkDetailsModel : NSObject
//任务名称
@property(nonatomic,copy)NSString *taskName;
//内容
@property(nonatomic,copy)NSString *taskContent;
//添加时间
@property(nonatomic,copy)NSString *addTime;
//状态
@property(nonatomic,copy)NSString *state;
//开始时间
@property(nonatomic,copy)NSString *bTime;
//结束时间
@property(nonatomic,copy)NSString *eTime;
//结果描述
@property(nonatomic,copy)NSString *resultStr;

@property(nonatomic,assign)CGFloat webY;
@end
