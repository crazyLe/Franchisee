//
//  KZWorkBaseInfoCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWorkIncomeView.h"
#import "KZCircleShowNumView.h"
#import <UIKit/UIKit.h>

@class KZWorkBaseInfoCell;

@protocol KZWorkBaseInfoCellDelegate <NSObject>

- (void)KZWorkBaseInfoCell:(KZWorkBaseInfoCell *)cell clickHowEarnBtn:(UIButton *)howEarnBtn;

@end

@interface KZWorkBaseInfoCell : UITableViewCell

@property (nonatomic,strong) UIButton *headBtn;

@property (nonatomic,strong) KZWorkIncomeView *incomeView;

@property (nonatomic,strong) UIButton *howEarnBtn;

@property (nonatomic,strong) UIView *bottomBgView;

@property (nonatomic,strong) KZCircleShowNumView *leftCircleView;

@property (nonatomic,strong) KZCircleShowNumView *centerCircleView;

@property (nonatomic,strong) KZCircleShowNumView *rightCircleView;

@property (nonatomic,assign) id <KZWorkBaseInfoCellDelegate> delegate;

@end
