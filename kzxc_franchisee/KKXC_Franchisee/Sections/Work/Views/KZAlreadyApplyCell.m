//
//  KZAlreadyApplyCell.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZAlreadyApplyCell.h"

@implementation KZAlreadyApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickReCommit:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(KZAlreadyApplyCell:clickReCommitBtn:)]) {
        [_delegate KZAlreadyApplyCell:self clickReCommitBtn:sender];
    }
}

@end
