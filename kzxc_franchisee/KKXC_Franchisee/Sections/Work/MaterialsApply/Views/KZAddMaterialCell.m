//
//  KZAddMaterialCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZAddMaterialCell.h"

@implementation KZAddMaterialCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)clickAddBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(KZAddMaterialCell:clickAddBtn:)]) {
        [_delegate KZAddMaterialCell:self clickAddBtn:(UIButton *)sender];
    }
}



@end
