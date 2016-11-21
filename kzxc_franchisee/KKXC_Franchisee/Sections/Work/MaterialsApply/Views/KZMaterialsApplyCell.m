//
//  KZMaterialsApplyCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMaterialModel.h"
#import "KZMaterialsApplyCell.h"

@implementation KZMaterialsApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.borderColor = [UIColor colorWithRed:248 green:248 blue:248 alpha:1.0].CGColor;
    _bgView.layer.borderWidth = 0.5f;
}

- (void)setModel:(KZMaterialModel *)model{
    if (_model != model) {
        _model = model;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[_model.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:kPlaceHolder_1_1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                _imgView.image = [UIImage imageNamed:kPlaceHolder_1_1];
            }
        }];
        
        _bottomLbl.text = _model.title;
    }
}

@end
