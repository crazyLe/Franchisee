//
//  KZWorkReportCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZNewsModel;

@interface KZWorkReportCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;

@property (weak, nonatomic) IBOutlet UILabel *rightLbl;

@property (nonatomic,strong) NSArray *newsContentModelArr;

@property (nonatomic,strong) KZNewsModel *currentModel; //记录当前正在显示的newsModel

@end
