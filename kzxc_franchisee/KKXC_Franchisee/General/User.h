//
//  User.h
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (copy, nonatomic) NSString *token;

@property (copy, nonatomic) NSString *uid;

@property (copy, nonatomic) NSString *nickName;

@property (copy, nonatomic) NSString *face;

@property (assign, nonatomic) NSInteger state;

@property (assign, nonatomic) NSInteger hasBuildFranchiseeInfo;

+ (instancetype)userWithDict:(NSDictionary *)dict;

/**
 清除用户信息
 */
+ (void)clearUserInfo;

@end
