//
//  KZWorkReportCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZNewsModel.h"
#import <BBCyclingLabel.h>
#import "KZWorkReportCell.h"

@interface KZWorkReportCell ()

@property (weak, nonatomic) IBOutlet BBCyclingLabel *cyclingLbl;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int rankIndex;

@end

@implementation KZWorkReportCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self prepareCyclingLbl];
}

- (void)prepareCyclingLbl{
    [_cyclingLbl setNeedsLayout];
    [_cyclingLbl.layer layoutIfNeeded];
    _cyclingLbl.numberOfLines = 1;
    _cyclingLbl.textColor = kGrayHex66;
    _cyclingLbl.font = kFont14;
    _cyclingLbl.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
    self.layer.masksToBounds = YES;
}

- (void)setNewsContentModelArr:(NSArray *)newsContentModelArr{
    if (_newsContentModelArr != newsContentModelArr) {
        _newsContentModelArr = newsContentModelArr;
        [self setTimer];
    }
}

#pragma mark - Timer

- (void)setTimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerHandle:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        [self setCyclingLblTextAnimated:NO];
    }
}

- (void)timerHandle:(NSTimer *)timer{
    [self setCyclingLblTextAnimated:YES];
}

- (void)setCyclingLblTextAnimated:(BOOL)animated{
    _rankIndex++;
    if (_rankIndex>=_newsContentModelArr.count) {
        _rankIndex=0;
    }
    if (_newsContentModelArr.count>_rankIndex) {
        KZNewsModel *newsModel = _newsContentModelArr[_rankIndex];
        _currentModel = newsModel;
        [_cyclingLbl setText:newsModel.content animated:animated];
    }
}

@end
