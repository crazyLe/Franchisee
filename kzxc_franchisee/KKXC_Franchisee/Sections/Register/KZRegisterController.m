//
//  KZRegisterController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZRegisterController.h"
#import "KZSelectIdentityController.h"
#import "User.h"

@interface KZRegisterController ()<UITextFieldDelegate>
{
    NSString * _phoneString;
    NSString * _validateString;
    NSString * _pswString;
    NSString * _confirmPswString;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *validateCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *setPswTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPswTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *browsePolicyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTop;
@property (weak, nonatomic) IBOutlet UILabel *remindLab;

@end

@implementation KZRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (isIPhone5) {
        
        _logoTop.constant = 10;
    }
    [self setNav];
    
    [self createUI];
    
    //后期删除这句话
    _registerBtn.enabled = YES;
    
    
}
- (void)createUI {
    
    [self setTextfiledValue:_phoneTF];
    [self setTextfiledValue:_validateCodeTF];
    [self setTextfiledValue:_setPswTF];
    [self setTextfiledValue:_confirmPswTF];
    
    _validateCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"9cc3eb"].CGColor;
    _validateCodeBtn.layer.borderWidth = 0.5;
    _validateCodeBtn.layer.cornerRadius = 3;
    _validateCodeBtn.clipsToBounds = YES;
    
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _validateCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _setPswTF.keyboardType = UIKeyboardTypeASCIICapable;
    _confirmPswTF.keyboardType = UIKeyboardTypeASCIICapable;
    
    _remindLab.alpha = 0;
    
}
- (void)setTextfiledValue:(UITextField *)view
{
    view.delegate = self;
    [view setValue:[UIColor colorWithHexString:@"5a6d83"] forKeyPath:@"_placeholderLabel.textColor"];
    //设置文字内容显示位置
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    view.leftView = paddingView;
    view.leftViewMode = UITextFieldViewModeAlways;
    
    view.textColor = [UIColor colorWithHexString:@"9cc3eb"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:view];
}

- (void)textFieldChanged:(NSNotification *)notification {
    
    UITextField * textField = (UITextField *)[notification object];
    switch (textField.tag) {
        case 101:
        {
            _phoneString = textField.text;
        }
            break;
        case 102:
        {
            _validateString = textField.text;
        }
            break;
        case 103:
        {
            _pswString = textField.text;
        }
            break;
        case 104:
        {
            _confirmPswString = textField.text;
        }
            break;
        default:
            break;
    }
    
    if (_phoneString.length != 0 && _validateString.length != 0  && _pswString.length != 0  && _confirmPswString.length != 0 ) {

        _registerBtn.backgroundColor = [UIColor colorWithHexString:@"9cc3eb"];
        [_registerBtn setTitleColor:[UIColor colorWithHexString:@"323842"] forState:UIControlStateNormal];
        _registerBtn.enabled = YES;
        
    }else {
        
        _registerBtn.backgroundColor = [UIColor colorWithHexString:@"2b3038"];
        [_registerBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _registerBtn.enabled = NO;
        
    }
    
    
}
- (void)setNav {
    
    self.title = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithRenderingMode:@"iconfont-login-back-copy"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
    
}
- (void)leftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 获取验证码的请求
- (IBAction)sendValidateCode:(id)sender {
    
    if (![ValidateHelper validateMobile:_phoneTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入正确的手机号" hideAfterDelay:1.0];
        return;
    }
   
    NSString * url = getValidateCodeUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = _phoneTF.text;
    paramDict[@"time"] = kTimeStamp;
    paramDict[@"flag"] = @"register";
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {

        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        NSLog(@"注册获取验证码%@",jsonObj);
        if (code == 1) {
            
            _remindLab.alpha = 1;
            _remindLab.text = @"验证码已发送";
            CGRect rect = _remindLab.frame;
            rect.size.width = rect.size.width + 40;
            rect.size.height = rect.size.height + 15;
            _remindLab.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
            [_remindLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(rect.size.width);
                make.height.offset(rect.size.height);
            }];

            [_validateCodeBtn setTitle:@"验证码已发送" forState:UIControlStateNormal];
            _validateCodeBtn.layer.borderColor = [UIColor clearColor].CGColor;
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"获取验证码失败" hideAfterDelay:1.0];
    }];
}
#pragma mark -- 注册的请求
- (IBAction)registerBtnClick:(id)sender {
    
    if (![ValidateHelper validateMobile:_phoneTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入正确手机号" hideAfterDelay:1.0];
        return;
    }
    
    if (6 != _validateCodeTF.text.length) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入6位数字验证码" hideAfterDelay:1.0];
        return;
    }
    
    if (![ValidateHelper validatePassword:_setPswTF.text] ) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入6~20位密码" hideAfterDelay:1.0];
        return;
    }
    if (_confirmPswTF.text.length == 0) {
        [self.hudManager showErrorSVHudWithTitle:@"请输入确认密码" hideAfterDelay:1.0];
        return;
    }
    if (![_setPswTF.text isEqualToString:_confirmPswTF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"两次密码输入不同" hideAfterDelay:1.0];
        return;
    }

    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    NSString * url = registerUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = _phoneTF.text;
    paramDict[@"code"] = _validateCodeTF.text;
    paramDict[@"password"] = _setPswTF.text;
    paramDict[@"push_id"] = pushID;
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        NSLog(@"注册%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString *msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            [User userWithDict:jsonObj[@"data"]];
            KZSelectIdentityController *selectCtl = [[KZSelectIdentityController alloc] init];
            [self.navigationController pushViewController:selectCtl animated:YES];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"网络不给力哦" hideAfterDelay:1.0];
    }];
}

- (IBAction)browsePolicyBtnClick:(id)sender {
    
    
    
}

@end
