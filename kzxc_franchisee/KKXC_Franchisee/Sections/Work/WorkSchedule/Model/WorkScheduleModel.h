//
//  WorkScheduleModel.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkScheduleModel : NSObject

//任务编号
@property(nonatomic,copy)NSString *taskId;
//结束时间戳
@property(nonatomic,copy)NSString *endTime;
//任务名称
@property(nonatomic,copy)NSString *taskName;
//任务描述
@property(nonatomic,copy)NSString *taskContent;

@end
