//
//  RemarksCell.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemarksModel.h"
@class RemarksCell;

typedef void(^deleteCurrentRemark)(RemarksCell *cell);

@interface RemarksCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *remarksContent;
@property (weak, nonatomic) IBOutlet UILabel *remarksTime;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *statusLine;

@property(nonatomic,strong)RemarksModel *model;

@property(nonatomic,copy)deleteCurrentRemark deleteBlock;
@end
