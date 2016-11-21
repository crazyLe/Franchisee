//
//  KZSchoolModel.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/25.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZSchoolModel : NSObject

@property (nonatomic,copy) NSString *areaId; //所在地区id

@property (nonatomic,copy) NSString *idNum;  //学校编号

@property (nonatomic,copy) NSString *schoolName; //学校名称

@end

/*
     json===>
     {
     code = 1;
     data =     (
     {
     areaId = 340100;
     id = 1;
     schoolName = "\U4e2d\U56fd\U79d1\U5b66\U6280\U672f\U5927\U5b66";
     },
     {
     areaId = 340100;
     id = 2;
     schoolName = "\U5b89\U5fbd\U5927\U5b66";
     }
     msg = "";
 }
 */
