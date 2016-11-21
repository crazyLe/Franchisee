//
//  KZFeedbackSuccessController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZFeedbackSuccessController.h"
#import "KZMineController.h"

@interface KZFeedbackSuccessController ()

@end

@implementation KZFeedbackSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationItem.title = @"";
    
    [self createUI];
    
}
- (void)createUI {
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}
- (IBAction)backBtnClick:(id)sender {
    
    //跳回个人中心
    KZMineController * mineCtl = [[KZMineController alloc] init];
    
    UIViewController * targetCtl = nil;
    
    for (UIViewController * controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[mineCtl class]]) {
            
            targetCtl = controller;
        }
    }
    if (targetCtl) {
        
        [self.navigationController popToViewController:targetCtl animated:YES];
    }

}

@end
