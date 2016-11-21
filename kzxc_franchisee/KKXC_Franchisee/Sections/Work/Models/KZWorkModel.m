//
//  KZWorkModel.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWorkModel.h"

@implementation KZWorkModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"banner":@"KZBannerModel",@"article":@"KZArticleModel",@"news":@"KZNewsModel"};
}

@end
