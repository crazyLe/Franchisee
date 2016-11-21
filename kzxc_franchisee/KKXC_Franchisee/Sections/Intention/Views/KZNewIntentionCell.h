//
//  KZNewIntentionCell.h
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZNewIntentionCell;

typedef void(^editRemarksWithCell)(KZNewIntentionCell *cell);

//打电话
@protocol KZNewIntentionCellDelegate <NSObject>

- (void)KZNewIntentionCellCallPhoneBtn:(UIButton *)btn;

@end

@interface KZNewIntentionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *registerStateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *remarkBtn;
@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;
@property(nonatomic,copy)NSString *customer_id;
@property(nonatomic,copy)NSString *customer_name;
@property(nonatomic,copy)editRemarksWithCell edit;

@property (nonatomic, weak) id<KZNewIntentionCellDelegate> delegate;

@end
