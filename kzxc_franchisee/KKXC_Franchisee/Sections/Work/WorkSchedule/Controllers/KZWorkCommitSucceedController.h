//
//  KZWorkCommitSucceedController.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZWorkCommitSucceedController : UIViewController

//描述数组
@property (strong, nonatomic) NSArray *desArray;
@property(nonatomic,copy)NSString *flag;

@property (weak, nonatomic) IBOutlet UILabel *showMsg;
@property (weak, nonatomic) IBOutlet UILabel *firstDes;
@property (weak, nonatomic) IBOutlet UILabel *secondDes;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end
