//
//  KZApplyCommitCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZApplyCommitCell.h"

@implementation KZApplyCommitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)textEditChanged:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(KZApplyCommitCell:textFieldEditChanged:)]) {
        [_delegate KZApplyCommitCell:self textFieldEditChanged:(UITextField *)sender];
    }
}

- (IBAction)textEditEnd:(id)sender {
    [self textEditChanged:sender];
}

@end
