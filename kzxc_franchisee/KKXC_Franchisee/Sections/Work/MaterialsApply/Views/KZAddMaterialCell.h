//
//  KZAddMaterialCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZAddMaterialCell;

@protocol KZAddMaterialCellDelegate <NSObject>

- (void)KZAddMaterialCell:(KZAddMaterialCell *)cell clickAddBtn:(UIButton *)addBtn;

@end

@interface KZAddMaterialCell : UITableViewCell

@property (nonatomic,assign) id <KZAddMaterialCellDelegate> delegate;

@end
