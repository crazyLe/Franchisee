//
//  KZMaterialsCollectionFooter.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMaterialsCollectionFooter.h"

@implementation KZMaterialsCollectionFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickApplyBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(KZMaterialsCollectionFooter:clickApplyBtn:)]) {
        [_delegate KZMaterialsCollectionFooter:self clickApplyBtn:(UIButton *)sender];
    }
}

@end
