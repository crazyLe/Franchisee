//
//  KZMaterialListCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMaterialListCell.h"

@implementation KZMaterialListCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (IBAction)clickBottomBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(KZMaterialListCell:clickBottomBtn:)]) {
        [_delegate KZMaterialListCell:self clickBottomBtn:(UIButton *)sender];
    }
}

- (void)setModel:(KZMyMaterialModel *)model{
    if (_model != model) {
        _model = model;
        _recipientsLbl.text = _model.userName;
        _addressLbl.text = _model.address;
        _materialLbl.text = _model.itemName;
        _timeLbl.text = [KZDateManager dateStrWithTimeStamp:_model.addTime dateFormat:@"yyyy-MM-dd HH:mm"];
        NSArray *colorArr = @[[UIColor colorWithHexString:@"7bcb1e"],[UIColor colorWithHexString:@"1d8fe1"],[UIColor colorWithHexString:@"ff801a"]];
        NSArray *textArr = @[@"审核中",@"通过",@"未通过"];
        int state = [_model.state intValue];
        NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:(state>=0 && state <3)?textArr[state]:@"" attributes:(state>=0 && state <3)?@[colorArr[state],kFont14]:@[kFont14]];
        if (!isEmptyStr(_model.failReson)) {
            [attStr appendText:[NSString stringWithFormat:@"(原因：%@)",_model.failReson] withAttributesArr:@[kGrayHex99,kFont14]];
        }
        if (state==1) {
            //通过
            [attStr appendText:@"(请注意查收快递)" withAttributesArr:@[kGrayHex99,kFont14]];
        }
        _stateLbl.attributedText = attStr;
        if (state==0) {
            //审核中
            [_bottomBtn setTitle:@"撤销" forState:UIControlStateNormal];
            _bottomBtn.hidden = NO;
        } else if(state==2){
            //未通过
            [_bottomBtn setTitle:@"重新提交" forState:UIControlStateNormal];
            _bottomBtn.hidden = NO;
        } else {
            _bottomBtn.hidden = YES;
        }
    }
}

@end
