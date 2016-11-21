//
//  KZAddressModel.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/25.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZAddressModel : NSObject <NSCoding>

@property (nonatomic,copy) NSString *idNum; //地区id

@property (nonatomic,copy) NSString *parentId; //父id

@property (nonatomic,copy) NSString *levelId;  //地区层级

@property (nonatomic,copy) NSString *areaName; //地区名称

@property (nonatomic,copy) NSString *areaPhonetic; //地区拼音

@property (nonatomic,copy) NSString *areaShortName; //地区短名称

@property (nonatomic,copy) NSString *isHot; //是否热门 （1是 0否）

@property (nonatomic,copy) NSString *latitude; //纬度

@property (nonatomic,copy) NSString *longitude; //经度

@end

//省model
@interface KZProvinceModel : KZAddressModel

@property (nonatomic,strong) NSArray <KZAddressModel *> *cityModelArr;

@end
