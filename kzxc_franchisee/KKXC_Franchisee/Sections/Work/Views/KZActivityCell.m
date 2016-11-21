//
//  ActivityCell.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZActivityCell.h"


@implementation KZActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(ActivityModel *)model {
    _model = model;
    NSURL *imagrUrl = [NSURL URLWithString:model.image];
    [_mainImage sd_setImageWithURL:imagrUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _activityTitle.text = model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
