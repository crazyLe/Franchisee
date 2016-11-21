//
//  KZInputParagraphCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZInputParagraphCell.h"

@implementation KZInputParagraphCell

- (void)awakeFromNib {
    [super awakeFromNib];

    WeakObj(_leftLbl)
    _textView = [[SZTextView alloc] init];
    [self.contentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.top.offset(12);
        make.bottom.offset(-12);
        make.right.offset(-15);
    }];
    _textView.placeholder = @"请输入";
    _textView.delegate = self;
    _textView.font = kFont16;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (_delegate && [_delegate respondsToSelector:@selector(KZInputParagraphCell:textDidChanged:)]) {
        [_delegate KZInputParagraphCell:self textDidChanged:_textView];
    }
}

@end
