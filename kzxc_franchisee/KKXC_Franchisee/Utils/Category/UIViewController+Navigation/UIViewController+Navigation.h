//
//  UIViewController+Navigation.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Navigation)

/**
 设置导航条title 
 1.titleText : 要设置的文本 
 2.color     : 文本颜色
 */
- (void)setTitleText:(NSString *)titleText textColor:(UIColor *)color;

/**
 同时设置导航条左侧和右侧按钮
 1.leftText          : 左侧按钮文本
 2.leftTextColor     : 左侧按钮文本颜色
 3.leftImgPath       : 左侧按钮图片名称
 4.leftBtnAction     : 左侧按钮绑定方法
 5.rightText         : 右侧按钮文本
 6.rightTextColor    : 右侧按钮文本颜色
 7.rightImgPath      : 右侧按钮图片名称
 8.rightBtnAction    : 右侧按钮绑定方法
 */
- (NSArray *)setLeftText:(NSString *)leftText leftTextColor:(UIColor *)leftTextColor
             leftImgPath:(NSString *)leftImgPath leftBtnAction:(SEL)leftBtnAction rightText:(NSString *)rightText rightTextColor:(UIColor *)rightTextColor rightImgPath:(NSString *)rightImgPath rightBtnAction:(SEL)rightBtnAction;

/**
 设置导航条左侧按钮
 1.leftText          : 左侧按钮文本
 2.leftTextColor     : 左侧按钮文本颜色
 3.leftImgPath       : 左侧按钮图片名称
 4.leftBtnAction     : 左侧按钮绑定方法
 */
- (UIButton *)setLeftText:(NSString *)leftText textColor:(UIColor *)color
                  ImgPath:(NSString *)imgPath action:(SEL)action;

/**
 设置导航条右侧按钮
 5.rightText         : 右侧按钮文本
 6.rightTextColor    : 右侧按钮文本颜色
 7.rightImgPath      : 右侧按钮图片名称
 8.rightBtnAction    : 右侧按钮绑定方法
 */
- (UIButton *)setRightText:(NSString *)rightText textColor:(UIColor *)color
                   ImgPath:(NSString *)imgPath action:(SEL)action;

- (void)setLeftBtnLeftInset:(CGFloat)offset button:(UIButton *)_leftBtn;

- (void)setRightBtnLeftInset:(CGFloat)offset button:(UIButton *)_rightBtn;

//block : 约束表的block , block传入nil即可添加默认约束UIEdgeInsetsMake(0, 0, 0, 0)
- (UITableView *)setBg_TableViewWithConstraints:(void(^)(MASConstraintMaker *make))block;

//nameArr : 注册的Cell类名字符串构成的数组
//indentifierArr : 对应得标识符，如果传入空值，则默认以类名字符串作为标识符
- (void)registerClassWithClassNameArr:(NSArray *)nameArr cellIdentifier:(NSArray *)identifierArr table:(UITableView *)_bg_TableView;
//nameArr : 注册的Cell类名字符串构成的数组
//indentifierArr : 对应得标识符，如果传入空值，则默认以类名字符串作为标识符
- (void)registerNibWithClassNameArr:(NSArray *)nameArr cellIdentifier:(NSArray *)identifierArr table:(UITableView *)_bg_TableView;

@end
