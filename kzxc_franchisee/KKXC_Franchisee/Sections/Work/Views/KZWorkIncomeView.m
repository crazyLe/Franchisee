//
//  KZWorkIncomeView.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#define kSigleNumWidth 25

#import "KZWorkIncomeView.h"

@implementation KZWorkIncomeView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _visibleBtn = [UIButton new];
        [self addSubview:_visibleBtn];
        [_visibleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.offset(0);
            make.width.height.offset(25);
        }];
        [_visibleBtn setImage:[UIImage imageNamed:@"iconfont-work-yanjing"] forState:UIControlStateNormal];
        [_visibleBtn setImage:[UIImage imageNamed:@"iconfont-work-biyan"] forState:UIControlStateSelected];
        [_visibleBtn addTarget:self action:@selector(clickVisibleBtn:) forControlEvents:UIControlEventTouchUpInside];
        _visibleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        WeakObj(_visibleBtn)
        _rightScrollNum = [[ZCWScrollNumView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
        [self addSubview:_rightScrollNum];
        [_rightScrollNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_visibleBtnWeak.mas_left);
            make.centerY.equalTo(_visibleBtnWeak);
            make.height.offset(kSigleNumWidth*2);
            make.width.offset(kSigleNumWidth*1.5);
        }];
        _rightScrollNum.numberSize = 2;
        _rightScrollNum.digitColor = kBlackThemeColor;
        _rightScrollNum.digitFont = [UIFont boldSystemFontOfSize:30*kWidthScale];
        _rightScrollNum.digitBackgroundView = [UIView new];
        [_rightScrollNum didConfigFinish];
        
        WeakObj(_rightScrollNum)
        _dotLbl = [UILabel new];
        [self addSubview:_dotLbl];
        [_dotLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightScrollNumWeak.mas_left).offset(isIPhone5?5:-5);
            make.bottom.height.equalTo(_rightScrollNumWeak);
            make.width.offset(kSigleNumWidth);
        }];
        _dotLbl.text = @".";
        _dotLbl.textColor = _rightScrollNum.digitColor;
        _dotLbl.textAlignment = NSTextAlignmentCenter;
        _dotLbl.font = _rightScrollNum.digitFont;
        
        WeakObj(_dotLbl)
        _leftScrollNum = [[ZCWScrollNumView alloc] initWithFrame:CGRectMake(0, 0, 110, 50)];
        [self addSubview:_leftScrollNum];
        [_leftScrollNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_dotLblWeak.mas_left).offset(isIPhone5?10:5);
            make.centerY.height.equalTo(_rightScrollNumWeak);
            make.width.offset(4*kSigleNumWidth+10);
        }];
        _leftScrollNum.digitColor = _rightScrollNum.digitColor;
        _leftScrollNum.digitFont = _rightScrollNum.digitFont;
        _leftScrollNum.digitBackgroundView = [UIView new];
        [_leftScrollNum didConfigFinish];
        
        WeakObj(_leftScrollNum)
        _bottomLbl = [UILabel new];
        [self addSubview:_bottomLbl];
        [_bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_leftScrollNumWeak);
//            make.right.equalTo(_rightScrollNumWeak);
            make.centerX.offset(15);
            make.top.equalTo(_leftScrollNumWeak.mas_bottom);
            make.height.offset(25);
        }];
        _bottomLbl.text = @"累计收益(元)";
        _bottomLbl.textColor = [UIColor colorWithHexString:@"ff801a"];
        _bottomLbl.font = kFont15;
        _bottomLbl.textAlignment = NSTextAlignmentCenter;
        
        WeakObj(_bottomLbl)
        _coverLbl = [UILabel new];
        [self addSubview:_coverLbl];
        [_coverLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_leftScrollNumWeak);
//            make.left.equalTo(_leftScrollNumWeak);
//            make.right.equalTo(_rightScrollNumWeak);
            make.centerX.equalTo(_bottomLblWeak);
            make.width.offset(80);
        }];
        _coverLbl.text = @"****";
        _coverLbl.textColor = _leftScrollNumWeak.digitColor;
        _coverLbl.font = _leftScrollNumWeak.digitFont;
        _coverLbl.hidden = YES;
        _coverLbl.backgroundColor = [UIColor whiteColor];
        _coverLbl.textAlignment = NSTextAlignmentCenter;
        
//        _leftScrollNumWeak.backgroundColor = [UIColor redColor];
//        _rightScrollNumWeak.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)clickVisibleBtn:(UIButton *)visibleBtn
{
    visibleBtn.selected = !visibleBtn.selected;
    _coverLbl.hidden = !visibleBtn.selected;
    _leftScrollNum.hidden = !_leftScrollNum.hidden;
    _dotLbl.hidden = !_dotLbl.hidden;
    _rightScrollNum.hidden = !_rightScrollNum.hidden;
}

- (void)setIncomeMoney:(CGFloat)income
{
    NSUInteger incomeInt =  (NSUInteger)income; //整数部分
    NSUInteger incomeDecimal = (NSUInteger)((income - incomeInt)*100); //小数部分
    
    _leftScrollNum.numberSize = [NSString stringWithFormat:@"%ld",incomeInt].length;
    
    if (_leftScrollNum.numberSize>=1 && _leftScrollNum.numberSize<=3) {
        switch (_leftScrollNum.numberSize) {
            case 1:
                [_visibleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-25*kWidthScale);
                }];
                break;
            case 2:
                [_visibleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-15*kWidthScale);
                }];
                break;
            case 3:
                [_visibleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-10*kWidthScale);
                }];
                break;
                
            default:
                break;
        }
        [_visibleBtn setNeedsLayout];
        [_visibleBtn.layer layoutIfNeeded];
    }
    
    for (UIView *view in _leftScrollNum.numberViews) {
        [view removeFromSuperview];
    }
    [_leftScrollNum didConfigFinish];
    
    [_leftScrollNum setNumber:incomeInt withAnimationType:ZCWScrollNumAnimationTypeNormal animationTime:0.7];
    [_rightScrollNum setNumber:incomeDecimal withAnimationType:ZCWScrollNumAnimationTypeNormal animationTime:0.7];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
