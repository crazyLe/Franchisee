//
//  KZIntentionRemarksController.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZIntentionRemarksController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(nonatomic,copy)NSString *customerId;
@property(nonatomic,copy)NSString *name;

@property (weak, nonatomic) IBOutlet UITableView *remarksTable;
@property (weak, nonatomic) IBOutlet UITextView *addremarksTextView;
@property (weak, nonatomic) IBOutlet UIButton *keepButtom;

@end
