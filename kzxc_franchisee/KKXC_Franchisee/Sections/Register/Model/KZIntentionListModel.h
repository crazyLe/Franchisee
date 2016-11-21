//
//  KZIntentionListModel.h
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZIntentionListModel : NSObject

@property (nonatomic, copy) NSString * customerId; //客户编号
@property (nonatomic, copy) NSString * userId; //0表示未注册
@property (nonatomic, copy) NSString * userName; //学员姓名
@property (nonatomic, copy) NSString * userFace; //用户头像
@property (nonatomic, copy) NSString * userTel; //用户电话
@property (nonatomic, copy) NSString * addTime; //订单时间


@end
