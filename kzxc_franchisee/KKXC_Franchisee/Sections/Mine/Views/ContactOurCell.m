//
//  ContactOurCell.m
//  KKXC_Franchisee
//
//  Created by gaobin on 16/8/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "ContactOurCell.h"

@implementation ContactOurCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    _customerServiceLab.layer.borderWidth = 1;
    _customerServiceLab.layer.borderColor = [UIColor colorWithHexString:@"5bb7ff"].CGColor;
    _customerServiceLab.layer.cornerRadius = 5;
    _customerServiceLab.clipsToBounds = YES;
    
    _businesLab.layer.borderWidth = 1;
    _businesLab.layer.borderColor = [UIColor colorWithHexString:@"5bb7ff"].CGColor;
    _businesLab.layer.cornerRadius = 5;
    _businesLab.clipsToBounds = YES;
    
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
