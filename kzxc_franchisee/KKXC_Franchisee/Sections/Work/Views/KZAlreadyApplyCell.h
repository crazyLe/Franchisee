//
//  KZAlreadyApplyCell.h
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZPercentageModel.h"
#import <UIKit/UIKit.h>

@class KZAlreadyApplyCell;

@protocol KZAlreadyApplyCellDelegate <NSObject>

- (void)KZAlreadyApplyCell:(KZAlreadyApplyCell *)cell clickReCommitBtn:(UIButton *)reCommitBtn;

@end

@interface KZAlreadyApplyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *applyMonnyTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *applyMonnyDetailLab;

@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@property (weak, nonatomic) IBOutlet UILabel *stateDetailLab;

@property (weak, nonatomic) IBOutlet UIButton *reApplyBtn;

@property (nonatomic,strong) KZPercentageModel *model;

@property (nonatomic,assign) id <KZAlreadyApplyCellDelegate> delegate;

@end
