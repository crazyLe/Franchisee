//
//  KZMaterialListCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMyMaterialModel.h"
#import <UIKit/UIKit.h>

@class KZMaterialListCell;

@protocol KZMaterialListCellDelegate <NSObject>

@optional

- (void)KZMaterialListCell:(KZMaterialListCell *)cell clickBottomBtn:(UIButton *)bottomBtn;

@end

@interface KZMaterialListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recipientsLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *materialLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (nonatomic,strong) KZMyMaterialModel *model;

@property (nonatomic,assign) id <KZMaterialListCellDelegate> delegate;

@end
