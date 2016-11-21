//
//  KZWorkOfficeCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "UIButton+KZExtension.h"
#import "KZWorkOfficeCell.h"

@implementation KZWorkOfficeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *btnArr = @[_cardBtn,_royaltyApplyBtn,_workManagementBtn,_activityManagementBtn,_trainBtn,_materialApplyBtn];
    int i = 0;
    for (UIButton *btn in btnArr) {
        [btn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextBottom imageTitleSpace:10];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10+i++;
    }
}

- (void)clickBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(KZWorkOfficeCell:clickBtn:)]) {
        [_delegate KZWorkOfficeCell:self clickBtn:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
