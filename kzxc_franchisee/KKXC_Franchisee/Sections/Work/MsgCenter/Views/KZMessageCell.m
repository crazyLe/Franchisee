//
//  KZMessageCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMessageModel.h"
#import "KZMessageCell.h"

@implementation KZMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(KZMessageModel *)model{
    if (_model != model) {
        _model = model;
//        _titleLbl.text = _model.title;
        _contentLbl.text = _model.title;
        _timeLbl.text = [KZDateManager dateStrWithTimeStamp:_model.addtime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _redView.hidden = [_model.isRead boolValue];
    }
}

- (IBAction)clickDeleteBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(KZMessageCell:clickDeleteBtn:)]) {
        [_delegate KZMessageCell:self clickDeleteBtn:sender];
    }
}

@end
