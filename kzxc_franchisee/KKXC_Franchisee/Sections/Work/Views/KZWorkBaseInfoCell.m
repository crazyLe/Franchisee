//
//  KZWorkBaseInfoCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWorkBaseInfoCell.h"

@implementation KZWorkBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setUI];
}

#pragma mark - Setup

- (void)setUI
{
    _headBtn = [UIButton new];
    [self.contentView addSubview:_headBtn];
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.width.height.offset(50*kWidthScale);
    }];
    _headBtn.layer.masksToBounds = YES;
    _headBtn.layer.cornerRadius = 50*kWidthScale/2;
    
    _howEarnBtn = [UIButton new];
    [self.contentView addSubview:_howEarnBtn];
    [_howEarnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(24);
        make.width.offset(70);
        make.height.offset(25);
    }];
    [_howEarnBtn setTitle:@"如何赚钱" forState:UIControlStateNormal];
    [_howEarnBtn setImage:[UIImage imageNamed:@"iconfont-work-help2"] forState:UIControlStateNormal];
    _howEarnBtn.titleLabel.font = kFont12;
    [_howEarnBtn setTitleColor:kGrayHex99 forState:UIControlStateNormal];
    [_howEarnBtn addTarget:self action:@selector(clickHowEarnBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    WeakObj(_howEarnBtn)
    WeakObj(_headBtn)
    _incomeView = [[KZWorkIncomeView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_incomeView];
    [_incomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_howEarnBtnWeak.mas_left);
        make.top.equalTo(_howEarnBtnWeak.mas_bottom);
        make.left.equalTo(_headBtnWeak.mas_right);
        make.height.offset(60);
    }];
    
    _bottomBgView = [UIView new];
    [self.contentView addSubview:_bottomBgView];
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.equalTo(_incomeView.mas_bottom).offset(15);
    }];
    
    CGFloat circleViewHeight = 100;
    CGFloat circleViewWidth = kScreenWidth/3;
    _leftCircleView = [[KZCircleShowNumView alloc] initWithFrame:CGRectMake(0, 0, circleViewWidth, circleViewHeight)];
    [_bottomBgView addSubview:_leftCircleView];
    _leftCircleView.promptLbl.text = @"意向报名";
    
    _centerCircleView = [[KZCircleShowNumView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftCircleView.frame), CGRectGetMinY(_leftCircleView.frame), circleViewWidth, circleViewHeight)];
    [_bottomBgView addSubview:_centerCircleView];
    _centerCircleView.promptLbl.text = @"APP注册量";
    
    _rightCircleView = [[KZCircleShowNumView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_centerCircleView.frame), CGRectGetMinY(_centerCircleView.frame), circleViewWidth, circleViewHeight)];
    [_bottomBgView addSubview:_rightCircleView];
    _rightCircleView.promptLbl.text = @"累计招生";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickHowEarnBtn:(UIButton *)howEarnBtn{
    if (_delegate && [_delegate respondsToSelector:@selector(KZWorkBaseInfoCell:clickHowEarnBtn:)]) {
        [_delegate KZWorkBaseInfoCell:self clickHowEarnBtn:howEarnBtn];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_howEarnBtn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextLeft imageTitleSpace:3];
}

@end
