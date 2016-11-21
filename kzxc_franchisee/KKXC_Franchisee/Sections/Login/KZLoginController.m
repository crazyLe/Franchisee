//
//  KZLoginController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZLoginController.h"
#import "KZResPswController.h"
#import "KZSelectIdentityController.h"
#import "KZTabBarController.h"
#import "User.h"

@interface KZLoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTop;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginTop;
@property (weak, nonatomic) IBOutlet UIButton *securityBtn;

@end

@implementation KZLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [self setTextfiledValue:_phoneTF  andtag:101];
    
    [self setTextfiledValue:_pswTF andtag:102];

    [self setNav];
    
}
- (void)setTextfiledValue:(UITextField *)view  andtag:(NSInteger)tag
{
    view.delegate = self;
    
    [view setValue:[UIColor colorWithHexString:@"5a6d83"] forKeyPath:@"_placeholderLabel.textColor"];
    //设置文字内容显示位置
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    view.leftView = paddingView;
    view.leftViewMode = UITextFieldViewModeAlways;
    
    view.textColor = [UIColor colorWithHexString:@"9cc3eb"];
    
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _pswTF.keyboardType = UIKeyboardTypeASCIICapable;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)setNav {
    
    self.title = @"";
    
    [self setLeftText:nil textColor:nil ImgPath:@"iconfont-login-back-copy" action:@selector(backBtnClick)];

}
- (void)backBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)loginBtnClick:(id)sender {
    
    if (![ValidateHelper validateMobile:_phoneTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入正确的手机号" hideAfterDelay:1.0];
        return;
    }
    if (![ValidateHelper validatePassword:_pswTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入6~20位密码" hideAfterDelay:1.0];
        return;
    }
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = loginUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];

    paramDict[@"phone"] = _phoneTF.text;
    paramDict[@"password"] = _pswTF.text;
    paramDict[@"channel"] = @"1";
    paramDict[@"push_id"] = pushID;
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"登录%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString *msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            User *user = [User userWithDict:jsonObj[@"data"]];
            if (user.hasBuildFranchiseeInfo == 0) {
                KZSelectIdentityController *selectIdentity = [[KZSelectIdentityController alloc] init];
                [self.navigationController pushViewController:selectIdentity animated:YES];
            } else {
                KZTabBarController *tabBarCtl = [[KZTabBarController alloc] init];
                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                window.rootViewController = tabBarCtl;
            }
            
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"登录失败" hideAfterDelay:1.0];
    }];
}

- (IBAction)resPswBtnClick:(id)sender {
    
    KZResPswController * resPswCtl = [[KZResPswController alloc] init];
    [self.navigationController pushViewController:resPswCtl animated:YES];
  
}

- (IBAction)securityBtnClick:(id)sender {
    
    _securityBtn.selected = !_securityBtn.selected;
    
    _pswTF.secureTextEntry = !_securityBtn.selected;

    
}

@end
