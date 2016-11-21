//
//  KZWorkCommitSucceedController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWorkCommitSucceedController.h"
#import "KZWorkScheduleController.h"

@interface KZWorkCommitSucceedController ()

@end

@implementation KZWorkCommitSucceedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bgView.layer.borderWidth = 1;
    _bgView.layer.cornerRadius = 4;
    
    _bgView.layer.borderColor = [UIColor colorWithHexString:@"#e8e8e8"].CGColor;
    
    [self.navigationController setLeftText:@"返回" textColor:nil ImgPath:@"iconfont-login-back-copy" action:@selector(goBack)];
    
    [_sureButton setBackgroundImage:[UIImage imageWithColor:[UIColor  colorWithHexString:@"17af69"]] forState:UIControlStateHighlighted];
    
    if ([_flag isEqualToString:@"nomal"]) {
        _desArray = @[@"工作日志已提交成功",@"今日事，今日毕"];
    } else {
        _desArray = @[@"工作提前完成申请已提交",@"哎呦！这么厉害"];
    }
    _showMsg.text = _desArray[0];
    _firstDes.text = _desArray[1];
    
}

- (void)goBack {
    NSArray *vcs =  [self.navigationController viewControllers];
    
    for (UIViewController *vc in vcs) {
        if ([vc isKindOfClass:[KZWorkScheduleController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (IBAction)popRootViewController:(UIButton *)sender {
    [self goBack];
}

@end
