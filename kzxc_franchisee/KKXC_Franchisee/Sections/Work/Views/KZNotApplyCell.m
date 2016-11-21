//
//  KZNotApplyCell.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZNotApplyCell.h"

@implementation KZNotApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)applyBtnClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(KZNotApplyCell:applyBtnClick:)]) {
        
        [_delegate KZNotApplyCell:self applyBtnClick:sender];
        
    }
    
    
    
}

@end
