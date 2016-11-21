//
//  KZWorkModel.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZWorkModel : NSObject

@property (nonatomic,copy) NSString *userFace;

@property (nonatomic,copy) NSString *customerNum;

@property (nonatomic,copy) NSString *regNum;

@property (nonatomic,copy) NSString *payNum;

@property (nonatomic,copy) NSString *userTotal;

@property (nonatomic,strong) NSArray *banner;

@property (nonatomic,strong) NSArray *article;

@property (nonatomic,strong) NSArray *news;

@end
