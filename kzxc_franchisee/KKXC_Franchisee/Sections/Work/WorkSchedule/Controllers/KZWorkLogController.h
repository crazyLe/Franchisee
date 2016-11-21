//
//  KZWorkLogController.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZWorkLogController : UIViewController
//任务编号
@property(nonatomic,copy)NSString *taskId;
//0 日志 1提前完成
@property(nonatomic,assign)int state;
@end
