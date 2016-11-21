//
//  KZActivityDetailController.h
//  KKXC_Franchisee
//
//  Created by sky on 2016/11/3.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface KZActivityDetailController : UIViewController

@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, strong) ActivityModel *activity;

@end
