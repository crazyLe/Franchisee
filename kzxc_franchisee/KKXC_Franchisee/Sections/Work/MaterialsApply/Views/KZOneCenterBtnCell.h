//
//  KZOneCenterBtnCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZOneCenterBtnCell;

@protocol KZOneCenterBtnCellDelegate <NSObject>

@optional

- (void)KZOneCenterBtnCell:(KZOneCenterBtnCell *)cell clickBtn:(UIButton *)btn;

@end

@interface KZOneCenterBtnCell : UITableViewCell

@property (nonatomic,assign) id <KZOneCenterBtnCellDelegate> delegate;

@end
