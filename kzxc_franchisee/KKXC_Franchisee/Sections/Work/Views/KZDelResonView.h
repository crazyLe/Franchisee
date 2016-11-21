//
//  KZDelResonView.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZDelResonView : UIView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView *table;

- (void)show;
- (void)hide;
@end
