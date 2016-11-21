//
//  KZAddressModel.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/25.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZAddressModel.h"

@implementation KZAddressModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"idNum":@"id"};
}

#pragma mark - 实现NSCoding协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_idNum forKey:@"idNum"];
    [aCoder encodeObject:_parentId forKey:@"parentId"];
    [aCoder encodeObject:_levelId forKey:@"levelId"];
    [aCoder encodeObject:_areaName forKey:@"areaName"];
    [aCoder encodeObject:_areaPhonetic forKey:@"areaPhonetic"];
    [aCoder encodeObject:_areaShortName forKey:@"areaShortName"];
    [aCoder encodeObject:_isHot forKey:@"isHot"];
    [aCoder encodeObject:_latitude forKey:@"latitude"];
    [aCoder encodeObject:_longitude forKey:@"longitude"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.idNum = [aDecoder decodeObjectForKey:@"idNum"];
        self.parentId = [aDecoder decodeObjectForKey:@"parentId"];
        self.levelId = [aDecoder decodeObjectForKey:@"levelId"];
        self.areaName = [aDecoder decodeObjectForKey:@"areaName"];
        self.areaPhonetic = [aDecoder decodeObjectForKey:@"areaPhonetic"];
        self.areaShortName = [aDecoder decodeObjectForKey:@"areaShortName"];
        self.isHot = [aDecoder decodeObjectForKey:@"isHot"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
    }
    return self;
}

@end

@implementation KZProvinceModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_cityModelArr forKey:@"cityModelArr"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.cityModelArr = [aDecoder decodeObjectForKey:@"cityModelArr"];
    }
    return self;
}
@end
