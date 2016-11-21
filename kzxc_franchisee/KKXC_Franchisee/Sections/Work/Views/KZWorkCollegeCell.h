//
//  KZWorkCollegeCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZArticleModel;

@interface KZWorkCollegeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *flagLbl;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;

@property (nonatomic,strong) KZArticleModel *articleModel;

@end
