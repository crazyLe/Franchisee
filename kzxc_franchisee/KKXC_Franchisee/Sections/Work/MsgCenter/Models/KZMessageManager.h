//
//  KZMessageManager.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMessageModel.h"
#import <Foundation/Foundation.h>

@interface KZMessageManager : NSObject

/**
 拉取服务器的新消息,并做本地缓存
 1.completionBlock : 完成时回调 isSuccess : 是否成功 YES==>成功 , NO==>失败
 */
+ (void)pullNewMessageWithCompletionBlock:(void(^)(BOOL isSuccess))completionBlock;

/**
 从数据库中读取所有的消息记录
 return : 返回 KZMessageModel 数组
 */
+ (NSArray <KZMessageModel *> *)readAllMessageFromDB;

/**
 设置某条消息已读
 1.model : 要设置已读的消息model
 */
+ (void)setMessageAlreadyRead:(KZMessageModel *)model;

/**
 删除某条消息
 1.model 要删除的消息model
 */
+ (void)deleteMessage:(KZMessageModel *)model;

/**
 查询所有未读消息
 return : 返回消息表中所有的未读消息model数组
 */
+ (NSArray *)queryAllUnReadMessage;

@end
