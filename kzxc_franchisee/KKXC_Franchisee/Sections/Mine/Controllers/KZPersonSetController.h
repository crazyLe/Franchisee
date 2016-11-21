//
//  KZPersonSetController.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/25.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHPickView.h"

@interface KZPersonSetController : UIViewController<UITableViewDelegate,UITableViewDataSource,ZHPickViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
