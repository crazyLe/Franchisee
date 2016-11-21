//
//  KZMyCardCell.m
//  KKXC_Franchisee
//
//  Created by sky on 2016/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMyCardCell.h"

@interface KZMyCardCell()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end


@implementation KZMyCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 6;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
