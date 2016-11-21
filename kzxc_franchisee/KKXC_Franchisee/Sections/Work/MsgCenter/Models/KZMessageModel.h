//
//  KZMessageModel.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZMessageModel : NSObject

@property (nonatomic,copy) NSString *idNum;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,copy) NSString *addtime;

@property (nonatomic,copy) NSString *isRead; //是否已读 @"0" ==> 未读 @"1" ==> 已读

@property (nonatomic,copy) NSString *msg_id;

@end
