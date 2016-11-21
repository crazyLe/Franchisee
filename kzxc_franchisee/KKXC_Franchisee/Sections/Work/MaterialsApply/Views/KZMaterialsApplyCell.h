//
//  KZMaterialsApplyCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

@class KZMaterialModel;
#import <UIKit/UIKit.h>

@interface KZMaterialsApplyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLbl;

@property (nonatomic,strong) KZMaterialModel *model;

@end
