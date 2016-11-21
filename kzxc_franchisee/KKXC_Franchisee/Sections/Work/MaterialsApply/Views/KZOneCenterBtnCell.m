//
//  KZOneCenterBtnCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZOneCenterBtnCell.h"

@implementation KZOneCenterBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(KZOneCenterBtnCell:clickBtn:)]) {
        [_delegate KZOneCenterBtnCell:self clickBtn:(UIButton *)sender];
    }
}

@end
