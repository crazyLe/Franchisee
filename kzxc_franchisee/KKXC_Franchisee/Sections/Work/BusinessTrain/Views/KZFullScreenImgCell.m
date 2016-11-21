//
//  KZFullScreenImgCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/28.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZBusinessTrainModel.h"
#import "KZFullScreenImgCell.h"

@implementation KZFullScreenImgCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _titleLbl.shadowColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    _titleLbl.shadowOffset = CGSizeMake(1, 1);
}

-(void)setModel:(KZBusinessTrainModel *)model{
    if (_model != model) {
        _model = model;
        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:[_model.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:kPlaceHolder_1_1]];
        _titleLbl.text = _model.title;
    }
}

@end
