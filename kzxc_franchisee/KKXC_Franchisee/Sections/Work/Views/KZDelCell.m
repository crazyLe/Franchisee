//
//  KZDelCell.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZDelCell.h"

@implementation KZDelCell
{
    NSInteger currentIndex;
    
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setButtonInsets:_firstOption];
    [self setButtonInsets:_secondOption];
    [self setButtonInsets:_threeOption];
    [self setButtonInsets:_fourOption];
    
//    _btnW.constant = (kScreenWidth - 90)/2;
//    _leftW.constant = (kScreenWidth - 90)/2;
    
    _btnW.constant = 145;
    _leftW.constant = 145;
    
    _otherOption.layer.borderWidth = 1;
    _otherOption.layer.borderColor = [UIColor colorWithHexString:@"#e8e8e8"].CGColor;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
    [self optionClick:_fourOption];
}
- (void)setButtonInsets:(UIButton *)btn
{
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
}
- (IBAction)optionClick:(UIButton *)sender {
    
    if (currentIndex != 0) {
        UIButton *oldButton =   [self viewWithTag:currentIndex];
        oldButton.selected = NO;
    }
    
    currentIndex = sender.tag;
    sender.selected = YES;
}

- (IBAction)cancle:(UIButton *)sender {
    self.cancleBlock();
}
- (IBAction)sure:(UIButton *)sender {
    
    if (0 == currentIndex) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择原因" hideAfterDelay:1.0];
        return;
    }
    NSString *reson;
    if (104 == currentIndex) {
        reson = _otherOption.text;
    } else {
        UIButton *button = [self viewWithTag:currentIndex];
        reson = button.titleLabel.text;
    }
//    self.sureBlock(reson);

    //发通知,传递cell信息

    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteFollowing" object:self userInfo:@{@"keyDelete":reson}];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
