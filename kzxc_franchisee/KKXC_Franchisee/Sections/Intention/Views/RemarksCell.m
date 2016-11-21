//
//  RemarksCell.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "RemarksCell.h"

@implementation RemarksCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RemarksModel *)model {
    _model = model;
    NSString *timeStr = [self getStamptimeWithString:model.addTime andSec:4];
    _remarksContent.text = model.content;
    _remarksTime.text = timeStr;
}
- (IBAction)deleteRemarks:(UIButton *)sender {
    
    self.deleteBlock(self);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
