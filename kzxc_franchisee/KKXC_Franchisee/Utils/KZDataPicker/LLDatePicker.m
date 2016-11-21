//
//  LLDatePicker.m
//  Coach
//
//  Created by LL on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

int const datePikerTag = 1200;

#import "LLDatePicker.h"

@implementation LLDatePicker
{
    NSDate *_date;
    NSDate *_minDate;
    NSDate *_maxDate;
    UIDatePickerMode _mode;
    CGRect _datePickerFrame;
    
    UIView *_coverView;
    
    UIView *_bgView;
    
    UIView *_toolBar;
    CGFloat _toolBarHeight;
    
    UIButton *_doneBtn;
    NSString *_doneBtnTitle;
}

+ (LLDatePicker *)showWithDate:(NSDate *)date minimumDate:(NSDate *)minDate maximumDate:(NSDate *)maxDate datePickerMode:(UIDatePickerMode)mode delegate:(id)delegate object:(id)obj
{
    UIView *oldView = [[UIApplication sharedApplication].keyWindow viewWithTag:datePikerTag];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    
    CGFloat datePickerHeight = 180*kHeightScale;
    
    LLDatePicker *pickerView = [[LLDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight-datePickerHeight, kScreenWidth, datePickerHeight) date:date minimumDate:minDate maximumDate:maxDate datePickerMode:mode object:obj];
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
    pickerView.delegate = delegate;
    pickerView.tag = datePikerTag;
    
//    pickerView.alpha = 0;
//    [UIView animateWithDuration:0.25f animations:^{
//        pickerView.alpha = 1;
//    }];
    
    return pickerView;
}

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date minimumDate:(NSDate *)minDate maximumDate:(NSDate *)maxDate datePickerMode:(UIDatePickerMode)mode object:(id)obj
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _date = date;
        _minDate = minDate;
        _maxDate = maxDate;
        _mode = mode;
        _datePickerFrame = frame;
        _toolBarHeight = 44;
        _doneBtnTitle = @"完成";
        _object = obj;
        [self setUI];
        [self setContraints];
        [self setAttributes];
    }
    return self;
}

#pragma mark - Setup

- (void)setUI
{
    _coverView = [UIView new];
    [self addSubview:_coverView];
    
    _toolBar = [UIView new];
    [self addSubview:_toolBar];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_toolBar addSubview:_doneBtn];
    
    _bgView = [UIView new];
    [self addSubview:_bgView];
    
    _datePicker = [[UIDatePicker alloc] init];
    [_bgView addSubview:_datePicker];
}

- (void)setContraints
{
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _bgView.frame = _datePickerFrame;
    
    WeakObj(_bgView)
    
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bgViewWeak);
        make.bottom.equalTo(_bgViewWeak.mas_top);
        make.height.offset(_toolBarHeight);
    }];
    
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.width.offset(70);
    }];
    
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setAttributes
{
    _coverView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5];
    
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _toolBar.backgroundColor = [UIColor whiteColor];
    
    [_doneBtn setTitle:_doneBtnTitle forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_doneBtn addTarget:self action:@selector(clickDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _datePicker.date = isNull(_date)?[NSDate date]:_date; // default is current date when picker created
    _datePicker.minimumDate = _minDate; // default is nil
    _datePicker.maximumDate = _maxDate; // default is nil
    _datePicker.datePickerMode = _mode; // default is UIDatePickerModeDateAndTime
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
    [self addGestureRecognizer:tap];
}

- (void)clickDoneBtn:(UIButton *)doneBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLDatePicker:clickDoneBtn:)]) {
        [_delegate LLDatePicker:self clickDoneBtn:doneBtn];
    }
    [LLDatePicker dismissFromView:[UIApplication sharedApplication].keyWindow];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLDatePicker:datePickerValueChanged:)]) {
        [_delegate LLDatePicker:self datePickerValueChanged:datePicker];
    }
}

- (void)tapSelf:(UITapGestureRecognizer *)tap
{
    [self clickDoneBtn:_doneBtn];
}

+ (void)dismissFromView:(UIView *)view
{
    UIView *datePickerView = [view viewWithTag:datePikerTag];
    if (!datePickerView) {
        return;
    }
    
    [UIView animateWithDuration:0.15f animations:^{
        datePickerView.alpha = 0;
    } completion:^(BOOL finished) {
        [datePickerView removeFromSuperview];
    }];
}

@end
