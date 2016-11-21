//
//  KZWorkOfficeCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZWorkOfficeCell;

@protocol KZWorkOfficeCellDelegate <NSObject>

@optional

- (void)KZWorkOfficeCell:(KZWorkOfficeCell *)cell clickBtn:(UIButton *)btn;

@end

@interface KZWorkOfficeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (weak, nonatomic) IBOutlet UIButton *royaltyApplyBtn;
@property (weak, nonatomic) IBOutlet UIButton *workManagementBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityManagementBtn;
@property (weak, nonatomic) IBOutlet UIButton *trainBtn;
@property (weak, nonatomic) IBOutlet UIButton *materialApplyBtn;

@property (nonatomic,assign) id <KZWorkOfficeCellDelegate> delegate;

@end
