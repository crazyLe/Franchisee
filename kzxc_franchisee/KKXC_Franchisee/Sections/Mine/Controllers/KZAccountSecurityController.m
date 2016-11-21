//
//  XXMMController.m
//  KKXC_Franchisee
//
//  Created by 翁昌青 on 16/8/4.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "User.h"
#import "KZAccountSecurityController.h"
#import "KZLoginController.h"

@interface KZAccountSecurityController ()

{
    int _oldSecond;
    int _newSecond;
    
    NSTimer *_timerOld;
    NSTimer *_timerNew;
}

@property (weak, nonatomic) IBOutlet UIView *pswview;
@property (weak, nonatomic) IBOutlet UIView *phoneview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswtop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phonetop;
@property (weak, nonatomic) IBOutlet UIButton *send;

//修改密码
@property (weak, nonatomic) IBOutlet UITextField *oldPswTF;
@property (weak, nonatomic) IBOutlet UITextField *newwPswTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPswTF;
@property (weak, nonatomic) IBOutlet UIButton *modifyPswBtn;
//修改手机号
@property (weak, nonatomic) IBOutlet UITextField *oldPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *oldCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *oldSendBtn;
@property (weak, nonatomic) IBOutlet UITextField *newwPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *newwCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *newwSendBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyPhoneBtn;
@end

@implementation KZAccountSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账号安全";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.send.layer.borderColor = [UIColor colorWithHexString:@"#4fa4ba"].CGColor;
    self.send.layer.borderWidth = 1;
    self.send.layer.cornerRadius = 5;
    _oldPswTF.secureTextEntry = YES;
    _newwPswTF.secureTextEntry = YES;
    _confirmNewPswTF.secureTextEntry = YES;
    
    if (_isFromGRSZ) {
        self.pswview.alpha = 1;
        _securitySegment.selectedSegmentIndex = 1;
    }else {
        self.phoneview.alpha = 0;
        _securitySegment.selectedSegmentIndex = 0;
    }
    if (isIPhpne4) {
        self.pswtop.constant = 15;
        self.phonetop.constant = 35;
    }
    _oldSecond = 60;
    _newSecond = 60;
}

- (IBAction)segClick:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.pswview.alpha = 1;
            self.phoneview.alpha = 0;
            break;
        case 1:
            self.pswview.alpha = 0;
            self.phoneview.alpha = 1;
            break;
            
        default:
            break;
    }
}
- (IBAction)modifyPswBtnClick:(id)sender {
    
    if (_oldPswTF.text.length == 0) {
        [self.hudManager showNormalStateSVHudWithTitle:@"请输入旧密码" hideAfterDelay:1.0];
        return;
    }
    if (_newwPswTF.text.length == 0) {
        [self.hudManager showNormalStateSVHudWithTitle:@"请输入新密码" hideAfterDelay:1.0];
        return;
    }
    if (![_newwPswTF.text isEqualToString:_confirmNewPswTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"两次输入的新密码不一致" hideAfterDelay:1.0];
        return;
    }
    
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中" hideAfterDelay:2.0];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"old_pwd"] = _oldPswTF.text;
    param[@"new_pwd"] = _newwPswTF.text;
    
    [KZNetworkEngine postWithUrl:modeifyPassword paraDic:param successBlock:^(id jsonObj) {
        
        int code = [jsonObj[@"code"] intValue];
        NSString *msg = jsonObj[@"msg"];
        if (1 == code) {
            [self.hudManager dismissSVHud];
            msg = (msg.length == 0)?@"密码修改成功":msg;
            UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil
                                                                              message:msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //退出登录,清除用户信息
                [User clearUserInfo];
                //跳转到登录界面
                KZLoginController *login = [[KZLoginController alloc]init];
                UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:login];
                root.navigationBar.translucent = NO;
                root.navigationBar.barTintColor = [UIColor colorWithHexString:@"323842"];
                [root.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
                root.navigationBar.shadowImage = [[UIImage alloc] init];
                
                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                window.rootViewController = root;
            }];
            [alertCtl addAction:sureAction];
            [self presentViewController:alertCtl animated:YES completion:nil];
        } else {
            msg = (msg.length == 0)?@"密码修改失败":msg;
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
    } failedBlock:^(NSError *error) {
        [self.hudManager dismissSVHud];
    }];
}
#pragma mark -- 修改手机号的请求
- (IBAction)modifyPhoneBtnClick:(id)sender {
    
    if (![ValidateHelper validateMobile:_oldPhoneTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"原手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    if (![ValidateHelper validateMobile:_newwPhoneTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"新手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"old_phone"] = _oldPhoneTF.text;
    paramDict[@"new_phone"] = _newwPhoneTF.text;
    paramDict[@"old_code"] = _oldCodeTF.text;
    paramDict[@"new_code"] = _newwCodeTF.text;
    
    [KZNetworkEngine postWithUrl:modeityPhone paraDic:paramDict successBlock:^(id jsonObj) {
        int code = [jsonObj[@"code"] intValue];
        NSString *msg = jsonObj[@"msg"];
        if (1 == code) {
            [self.hudManager dismissSVHud];
            msg = (msg.length != 0)?msg:@"手机号修改成功";
            UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil
                                                                              message:msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //退出登录,清除用户信息
                [User clearUserInfo];
                //跳转到登录界面
                KZLoginController *login = [[KZLoginController alloc]init];
                UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:login];
                root.navigationBar.translucent = NO;
                root.navigationBar.barTintColor = [UIColor colorWithHexString:@"323842"];
                [root.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
                root.navigationBar.shadowImage = [[UIImage alloc] init];
                
                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                window.rootViewController = root;
            }];
            [alertCtl addAction:sureAction];
            [self presentViewController:alertCtl animated:YES completion:nil];
        } else {
            msg = (msg.length != 0)?msg:@"手机号修改失败";
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
    } failedBlock:^(NSError *error) {
        [self.hudManager dismissSVHud];
    }];
    
}
#pragma mark -- 获取旧手机号的验证码的请求
- (IBAction)getOldPhoneCode:(id)sender {
    
    if (![ValidateHelper validateMobile:_oldPhoneTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"原手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = _oldPhoneTF.text;
    paramDict[@"time"] = self.getcurrentTime;
    paramDict[@"flag"] = @"change";
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"加载中"];
    [KZNetworkEngine postWithUrl:getValidateCodeUrl paraDic:paramDict successBlock:^(id jsonObj) {
        int code = [jsonObj[@"code"] intValue];
        NSString *msg = jsonObj[@"msg"];
        if (1 == code) {
            msg = (msg.length == 0)?@"验证码发送成功":msg;
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
            
            _oldSendBtn.enabled = NO;
            //倒计时
            _timerOld =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(oldTimeChange) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:_timerOld forMode:NSRunLoopCommonModes];
            
        } else {
            msg = (msg.length == 0)?@"验证码发送失败":msg;
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        
    }];
}
- (void)oldTimeChange {
    NSString *titlestr = [NSString stringWithFormat:@"已发送(%ds)",_oldSecond];
    [_oldSendBtn setTitle:titlestr forState:UIControlStateNormal];
    _oldSecond -- ;
    if (-1 == _oldSecond) {
        _oldSecond = 60;
        [_oldSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _oldSendBtn.enabled = YES;
        [_timerOld invalidate];
    }
}
#pragma mark -- 获取新手机号的验证码的请求
- (IBAction)getNewPhoneCode:(id)sender {
    
    if (![ValidateHelper validateMobile:_newwPhoneTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"新手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = _newwPhoneTF.text;
    paramDict[@"time"] = self.getcurrentTime;
    paramDict[@"flag"] = @"change";
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"加载中"];
    [KZNetworkEngine postWithUrl:getValidateCodeUrl paraDic:paramDict successBlock:^(id jsonObj) {
        int code = [jsonObj[@"code"] intValue];
        NSString *msg = jsonObj[@"msg"];
        if (1 == code) {
            msg = (msg.length == 0)?@"验证码发送成功":msg;
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
            _newwSendBtn.enabled = NO;
            //倒计时
            _timerNew = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(newTimeChange) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:_timerNew forMode:NSRunLoopCommonModes];
            
        } else {
            msg = (msg.length == 0)?@"验证码发送失败":msg;
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager dismissSVHud];
    }];
}

- (void)newTimeChange {
    NSString *titlestr = [NSString stringWithFormat:@"已发送(%ds)",_newSecond];
    [_newwSendBtn setTitle:titlestr forState:UIControlStateNormal];
    _newSecond -- ;
    if (-1 == _newSecond) {
        _newSecond = 60;
        [_newwSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _newwSendBtn.enabled = YES;
        [_timerNew invalidate];
    }
}

@end
