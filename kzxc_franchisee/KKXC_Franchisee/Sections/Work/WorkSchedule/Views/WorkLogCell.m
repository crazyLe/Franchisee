//
//  WorkLogCell.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "WorkLogCell.h"

@implementation WorkLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _commitContent.delegate = self;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请在此输入当天工作情况,请勿在0点左右提交，以免发生数据传输错误"]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(sendRemarksContent:)]) {
        [_delegate sendRemarksContent:textView.text];
    }
}

- (IBAction)addImage:(UIButton *)sender {
    
    NSLog(@"%d",(int)sender.tag);
    NSInteger tag = sender.tag;
    switch (tag) {
        case 101:
        {
            if ([_delegate respondsToSelector:@selector(addPhoto:andTag:)]) {
                [_delegate addPhoto:sender andTag:101];
            }
        }
            break;
            
        case 102:
        {
            if ([_delegate respondsToSelector:@selector(addPhoto:andTag:)]) {
                [_delegate addPhoto:sender andTag:102];
            }
        }
            break;
        case 103:
        {
            if ([_delegate respondsToSelector:@selector(addPhoto:andTag:)]) {
                [_delegate addPhoto:sender andTag:103];
            }
        }
            break;
        case 104:
        {
            if ([_delegate respondsToSelector:@selector(gotoCommitResultController)]) {
                [_delegate gotoCommitResultController];
            }
        }
            break;
            
        default:
            break;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
