//
//  KZNotApplyCell.h
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZPercentageModel.h"
#import <UIKit/UIKit.h>

@class KZNotApplyCell;

@protocol KZNotApplyCellDelegate <NSObject>

- (void)KZNotApplyCell:(KZNotApplyCell *)cell applyBtnClick:(UIButton *)btn;

@end

@interface KZNotApplyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UIButton *applyBtn;

@property (nonatomic,strong) KZPercentageModel *model;

@property (nonatomic, weak) id<KZNotApplyCellDelegate> delegate;


@end
