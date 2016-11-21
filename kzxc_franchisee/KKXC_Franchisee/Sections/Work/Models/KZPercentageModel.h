//
//  KZPercentageModel.h
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/25.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZPercentageModel : NSObject

//@property (nonatomic, copy) NSString * payNum; //本月累计招生
//@property (nonatomic, copy) NSString * payNumToday; //今日累计招生

@property (nonatomic, copy) NSString * orderId; //订单编号
@property (nonatomic, copy) NSString * userName; //学员姓名
@property (nonatomic, copy) NSString * productName; //产品名称
@property (nonatomic, copy) NSString * productPrice; //产品价格
@property (nonatomic, copy) NSString * addTime; //添加时间
@property (nonatomic, copy) NSString * applyMoney;
@property (nonatomic, copy) NSString * applyTime;
@property (nonatomic, copy) NSString * applyState;
@property (nonatomic, copy) NSString * applyStateStr;

@end
