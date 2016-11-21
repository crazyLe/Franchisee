//
//  KZApplyCommitCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZApplyCommitCell;

@protocol KZApplyCommitCellDelegate <NSObject>

@optional

- (void)KZApplyCommitCell:(KZApplyCommitCell *)cell textFieldEditChanged:(UITextField *)textField;

@end

@interface KZApplyCommitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLbl;
@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImgView;

@property (nonatomic,assign) id <KZApplyCommitCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
