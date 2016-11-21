//
//  UIViewController+Navigation.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

- (void)setTitleText:(NSString *)titleText textColor:(UIColor *)color
{
    self.title = titleText;
    [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:color==nil?[UIColor colorWithHexString:@"444b54"]:color}];
}


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
                 leftImgPath:(NSString *)leftImgPath leftBtnAction:(SEL)leftBtnAction rightText:(NSString *)rightText rightTextColor:(UIColor *)rightTextColor rightImgPath:(NSString *)rightImgPath rightBtnAction:(SEL)rightBtnAction
{
    UIButton *leftBtn = nil;
    UIButton *rightBtn = nil;
    
    if (!isEmptyStr(leftText) || isEmptyStr(leftImgPath)) {
        leftBtn = [self setLeftText:leftText textColor:leftTextColor ImgPath:leftImgPath action:leftBtnAction];
    } else {
        leftBtn = [UIButton new];
    }
    if (!isEmptyStr(rightText) || isEmptyStr(rightImgPath)) {
       rightBtn = [self setRightText:rightText textColor:rightTextColor ImgPath:rightImgPath action:rightBtnAction];
    } else {
        rightBtn = [UIButton new];
    }
    
    return @[leftBtn,rightBtn];
}

/**
 设置导航条左侧按钮
 1.leftText          : 左侧按钮文本
 2.leftTextColor     : 左侧按钮文本颜色
 3.leftImgPath       : 左侧按钮图片名称
 4.leftBtnAction     : 左侧按钮绑定方法
 */
- (UIButton *)setLeftText:(NSString *)leftText textColor:(UIColor *)color
                  ImgPath:(NSString *)imgPath action:(SEL)action
{
    if (!leftText && !imgPath) {
        return nil;
    }
    
    UIButton *_leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, 0, 70, 30);
    if (imgPath) {
        [_leftBtn setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
    }
    if (leftText) {
        [_leftBtn setTitle:leftText forState:UIControlStateNormal];
        [_leftBtn setTitleColor:color==nil?[UIColor whiteColor]:color forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = Font15;
    }
    if (leftText && imgPath) {
        UIImage *leftBtnImg = [UIImage imageNamed:imgPath];
        [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -leftBtnImg.size.width, 0, leftBtnImg.size.width)];
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -35)];
    }
    [_leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_leftBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
    [_leftBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    return _leftBtn;
}

/**
 设置导航条右侧按钮
 5.rightText         : 右侧按钮文本
 6.rightTextColor    : 右侧按钮文本颜色
 7.rightImgPath      : 右侧按钮图片名称
 8.rightBtnAction    : 右侧按钮绑定方法
 */
- (UIButton *)setRightText:(NSString *)rightText textColor:(UIColor *)color
             ImgPath:(NSString *)imgPath action:(SEL)action
{
    if (!rightText && !imgPath) {
        return nil;
    }
    
    UIButton *_rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 70, 30);
    if (imgPath) {
        [_rightBtn setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
    }
    if (rightText) {
        [_rightBtn setTitle:rightText forState:UIControlStateNormal];
        [_rightBtn setTitleColor:color==nil?[UIColor whiteColor]:color forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = Font15;
    }
    if (rightText && imgPath) {
        //        UIImage *rightBtnImg = [UIImage imageNamed:imgPath];
        //        [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -rightBtnImg.size.width, 0, rightBtnImg.size.width)];
        //        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -35)];
    }
    [_rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_rightBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    
    [_rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    return _rightBtn;
}

- (void)setLeftBtnLeftInset:(CGFloat)offset button:(UIButton *)_leftBtn
{
    [_leftBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -offset, 0, offset)];
    [_leftBtn setNeedsDisplay];
    [_leftBtn.layer displayIfNeeded];
}

- (void)setRightBtnLeftInset:(CGFloat)offset button:(UIButton *)_rightBtn
{
    [_rightBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -offset, 0, offset)];
    [_rightBtn setNeedsDisplay];
    [_rightBtn.layer displayIfNeeded];
}

//block : 约束表的block , block传入nil即可添加默认约束UIEdgeInsetsMake(0, 0, 0, 0)
- (UITableView *)setBg_TableViewWithConstraints:(void(^)(MASConstraintMaker *make))block
{
    UITableView *_bg_TableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_bg_TableView];
    [_bg_TableView mas_makeConstraints: block==nil? ^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    } : block];
    _bg_TableView.delegate = self;
    _bg_TableView.dataSource = self;
    _bg_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _bg_TableView;
}

//nameArr : 注册的Cell类名字符串构成的数组
//indentifierArr : 对应得标识符，如果传入空值，则默认以类名字符串作为标识符
- (void)registerClassWithClassNameArr:(NSArray *)nameArr cellIdentifier:(NSArray *)identifierArr table:(UITableView *)_bg_TableView
{
    if (!nameArr.count) {
        return;
    }
    for (int i = 0; i < nameArr.count; i++) {
        [_bg_TableView registerClass:NSClassFromString(nameArr[i]) forCellReuseIdentifier:identifierArr==nil?nameArr[i]:identifierArr[i]];
    }
}

//nameArr : 注册的Cell类名字符串构成的数组
//indentifierArr : 对应得标识符，如果传入空值，则默认以类名字符串作为标识符
- (void)registerNibWithClassNameArr:(NSArray *)nameArr cellIdentifier:(NSArray *)identifierArr table:(UITableView *)_bg_TableView
{
    if (!nameArr.count) {
        return;
    }
    for (int i = 0; i < nameArr.count; i++) {
        [_bg_TableView registerNib:[UINib nibWithNibName:nameArr[i] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifierArr==nil?nameArr[i]:identifierArr[i]];
    }
}

@end
