//
//  WorkScheduleCell.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkScheduleModel.h"

@interface WorkScheduleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *leftIconTitle;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *dateStr;
@property (weak, nonatomic) IBOutlet UILabel *personNum;
@property (weak, nonatomic) IBOutlet UILabel *detailsContent;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

//当前状态
@property(nonatomic,copy)NSString *currentStatue;

@property(nonatomic,strong)WorkScheduleModel *model;

@end
