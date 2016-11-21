//
//  KZFullScreenImgCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/28.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZBusinessTrainModel;

@interface KZFullScreenImgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (nonatomic,strong) KZBusinessTrainModel *model;

@end
