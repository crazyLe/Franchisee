//
//  KZDelCell.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^cancleButtonClick)();
typedef void(^sureButtonClick)(NSString *resonStr);

@interface KZDelCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *firstOption;
@property (weak, nonatomic) IBOutlet UIButton *secondOption;
@property (weak, nonatomic) IBOutlet UIButton *threeOption;
@property (weak, nonatomic) IBOutlet UIButton *fourOption;
@property (weak, nonatomic) IBOutlet UITextView *otherOption;
@property (weak, nonatomic) IBOutlet UIButton *cancle;
@property (weak, nonatomic) IBOutlet UIButton *sure;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftW;

@property(nonatomic,copy)cancleButtonClick cancleBlock;
@property(nonatomic,copy)sureButtonClick sureBlock;

@end
