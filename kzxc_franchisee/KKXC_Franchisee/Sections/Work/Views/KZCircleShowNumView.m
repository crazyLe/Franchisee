//
//  KZCircleShowNumView.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZCircleShowNumView.h"

@implementation KZCircleShowNumView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _promptLbl = [UILabel new];
        [self addSubview:_promptLbl];
        [_promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.offset(0);
            make.height.offset(20);
        }];
        _promptLbl.textColor = kGrayHex99;
//        _promptLbl.font = kFont11;

        WeakObj(_promptLbl)
        _circleLbl = [UILabel new];
        [self addSubview:_circleLbl];
        [_circleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.bottom.equalTo(_promptLblWeak.mas_top).offset(-7.5);
        }];
        _circleLbl.textColor = kBlackThemeColor;
//        _circleLbl.font = kFont15;
        _circleLbl.layer.borderColor = kGrayHex99.CGColor;
        _circleLbl.layer.borderWidth = 0.5f;
        _circleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setShowNum:(NSString *)num
{
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:num attributes:@[kBlackThemeColor,[UIFont boldSystemFontOfSize:15*kWidthScale]]];
    if ([num intValue]>0) {
       [attStr appendText:@"人" withAttributesArr:@[kBlackThemeColor,kFont11]];
    }
    _circleLbl.attributedText = attStr;
    
//    CGFloat width = [attStr.string sizeWithAttributes:@{NSFontAttributeName: kFont11}].width+20;
    CGFloat width = 60;
    
    [_circleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(width);
    }];
    
    _circleLbl.layer.cornerRadius = width/2;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
