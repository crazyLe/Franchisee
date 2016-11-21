//
//  KZSelectIdentityController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZSelectIdentityController.h"
#import "KZStudentInfoController.h"
#import "KZAssociationInfoController.h"
#import "KZBusinessInfoController.h"

@interface KZSelectIdentityController ()

@property (weak, nonatomic) IBOutlet UIButton *studentBtn;
@property (weak, nonatomic) IBOutlet UIButton *associationBtn;
@property (weak, nonatomic) IBOutlet UIButton *businessmanBtn;

@end

@implementation KZSelectIdentityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setNavigation];
    
    
}
- (void)setNavigation {
    
    [self setTitleText:@"基本信息 (1/2)" textColor:[UIColor colorWithHexString:@"9cc3eb"]];
    [self setLeftText:nil textColor:nil ImgPath:@"" action:nil];
    
}
- (IBAction)selectBtnClick:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case 101:
        {
            KZStudentInfoController * basicCtl = [[KZStudentInfoController alloc] init];
            [self.navigationController pushViewController:basicCtl animated:YES];
        }
            break;
        case 102:
        {
            KZAssociationInfoController * basicCtl = [[KZAssociationInfoController alloc] init];
            [self.navigationController pushViewController:basicCtl animated:YES];
        }
            break;
        case 103:
        {
            KZBusinessInfoController * basicCtl = [[KZBusinessInfoController alloc] init];
            [self.navigationController pushViewController:basicCtl animated:YES];
        }
            break;
        default:
            break;
    }

    
    
}



@end
