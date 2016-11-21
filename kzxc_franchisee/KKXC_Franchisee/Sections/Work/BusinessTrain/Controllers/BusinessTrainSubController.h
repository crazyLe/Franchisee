//
//  BusinessTrainSubController.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BusinessTrainSubControllerTypeAll = 0, //全部
    BusinessTrainSubControllerTypeArticle, //文章
    BusinessTrainSubControllerTypeVedio,  //视频
    BusinessTrainSubControllerTypeImage //图片
}BusinessTrainSubControllerType;

@interface BusinessTrainSubController : UIViewController

@property (nonatomic,assign)BusinessTrainSubControllerType type;

@property (nonatomic,strong) NSArray *dataSource;

@end
