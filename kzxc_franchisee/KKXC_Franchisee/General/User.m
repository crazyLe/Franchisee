//
//  User.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "User.h"

@implementation User


- (instancetype)init {
    
    if (self = [super init])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
        });
    }
    return self;
}

+ (instancetype)userWithDict:(NSDictionary *)dict {
    
    User *user = [[User alloc]init];
    user.uid = dict[@"uid"];
    user.token = dict[@"KZToken"];
    user.nickName = dict[@"nickName"];
    user.face = dict[@"face"];
    user.state = [dict[@"state"] integerValue];
    user.hasBuildFranchiseeInfo = [dict[@"hasBuildFranchiseeInfo"] integerValue];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:user.uid forKey:@"kUid"];
    [defaults setValue:user.token forKey:@"kToken"];
    [defaults setValue:user.nickName forKey:@"nickName"];
    [defaults setValue:user.face forKey:@"face"];
    [defaults setBool:YES forKey:@"isLogin"];
    
    if (user.hasBuildFranchiseeInfo != 0) {
        [defaults setBool:YES forKey:@"kHasBuildFranchiseeInfo"];
    }
    NSLog(@"%@",user.token);
    [defaults synchronize];
    return user;
}

/**
 清除用户信息
 */
+ (void)clearUserInfo{
    [kUserDefault setValue:@"" forKey:@"kUid"];
    [kUserDefault setValue:@"" forKey:@"kToken"];
    [kUserDefault setValue:@"" forKey:@"nickName"];
    [kUserDefault setValue:@"" forKey:@"face"];
    [kUserDefault setBool:NO forKey:@"isLogin"];
    [kUserDefault setObject:nil forKey:@"kBindState"];
    [kUserDefault setBool:NO forKey:@"kHasBuildFranchiseeInfo"];
}

@end
