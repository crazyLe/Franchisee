//
//  KZMessageCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZMessageModel;

@class KZMessageCell;

@protocol KZMessageCellDelegate <NSObject>

- (void)KZMessageCell:(KZMessageCell *)cell clickDeleteBtn:(UIButton *)deleteBtn;

@end

@interface KZMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (nonatomic,strong) KZMessageModel *model;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id <KZMessageCellDelegate> delegate;

@end
