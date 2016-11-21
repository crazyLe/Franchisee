//
//  WorkScheduleCell.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "WorkScheduleCell.h"

@implementation WorkScheduleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCurrentStatue:(NSString *)currentStatue
{
    _currentStatue = currentStatue;
    
    NSString *leftiIconStr;
    NSString *rightIconStr;
    NSString *colorStr;
    
    if ([currentStatue isEqualToString:@"doing"]) {
        leftiIconStr = @"doing_dateicon";
        rightIconStr = @"doing_right_icon";
        colorStr = @"#1d86e1";
    } else if([currentStatue isEqualToString:@"star"]) {
        leftiIconStr = @"star_dateicon";
        rightIconStr = @"star_right_icon";
        colorStr = @"#17af69";
    } else if ([currentStatue isEqualToString:@"end"]) {
        leftiIconStr = @"end_dateicon";
        rightIconStr = @"end_right_icon";
        colorStr = @"#c8c8c8";
    }
    
    [self setLeftImage:leftiIconStr andRightImage:rightIconStr andDateTextColor:colorStr];
}

- (void)setLeftImage:(NSString *)leftIconStr andRightImage:(NSString *)rightIconStr andDateTextColor:(NSString *)colorStr {
    _leftIcon.image = [UIImage imageNamed:leftIconStr];
    _rightIcon.image = [UIImage imageNamed:rightIconStr];
    _day.textColor = [UIColor colorWithHexString:colorStr];
    _dateStr.textColor = [UIColor colorWithHexString:colorStr];
}

- (void)setModel:(WorkScheduleModel *)model {
    _model = model;
    _personNum.text = model.taskName;
   NSString *timeStr = [self getStamptimeWithString:model.endTime andSec:0];
    _day.text = [NSString stringWithFormat:@"%d",[[timeStr substringFromIndex:8] intValue]];
    _dateStr.text = [timeStr substringWithRange:NSMakeRange(0, 7)];
    _detailsContent.text = model.taskContent;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
