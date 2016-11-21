//
//  KZWorkIncomeView.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "ZCWScrollNumView.h"
#import <UIKit/UIKit.h>

@interface KZWorkIncomeView : UIView

@property (nonatomic,strong) ZCWScrollNumView *leftScrollNum;

@property (nonatomic,strong) ZCWScrollNumView *rightScrollNum;

@property (nonatomic,strong) UILabel *dotLbl;

@property (nonatomic,strong) UILabel *bottomLbl;

@property (nonatomic,strong) UIButton *visibleBtn;

@property (nonatomic,strong) UILabel *coverLbl;

- (void)setIncomeMoney:(CGFloat)income;

@end
