//
//  KZNewIntentionCell.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZNewIntentionCell.h"

@implementation KZNewIntentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)editRemarks:(id)sender {
    
    self.edit(self);
}
- (IBAction)callPhoneBtnClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(KZNewIntentionCellCallPhoneBtn:)]) {
        
        [_delegate KZNewIntentionCellCallPhoneBtn:_callPhoneBtn];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
