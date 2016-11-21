//
//  LLDatePicker.h
//  Coach
//
//  Created by LL on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLDatePicker;

@protocol LLDatePickerDelegate <NSObject>

- (void)LLDatePicker:(LLDatePicker *)view datePickerValueChanged:(UIDatePicker *)datePicker;

- (void)LLDatePicker:(LLDatePicker *)view clickDoneBtn:(UIButton *)doneBtn;

@end

@interface LLDatePicker : UIView

+ (LLDatePicker *)showWithDate:(NSDate *)date minimumDate:(NSDate *)minDate maximumDate:(NSDate *)maxDate datePickerMode:(UIDatePickerMode)mode delegate:(id)delegate object:(id)obj;

+ (void)dismissFromView:(UIView *)view;  //移除DatePickerView

@property (nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic,assign) id delegate;

@property (nonatomic,strong) id object;  //default is nil

@end
