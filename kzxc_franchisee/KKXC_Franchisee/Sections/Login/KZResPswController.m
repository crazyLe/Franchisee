//
//  KZResPswController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZResPswController.h"


@interface KZResPswController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPswTF;
@property (weak, nonatomic) IBOutlet UIButton *modifyPswBtn;
@property (weak, nonatomic) IBOutlet UIButton *pswSecurityBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmPswSecurityBtn;
@property (weak, nonatomic) IBOutlet UIButton *validateCodeBtn;

@end

@implementation KZResPswController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setupNav];

    [self createUI];
    
}
- (void)createUI {
    
    
    [self setTextfiledValue:_phoneTF];
    [self setTextfiledValue:_validateCodeTF];
    [self setTextfiledValue:_pswTF];
    [self setTextfiledValue:_confirmPswTF];
    _validateCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"9cc3eb"].CGColor;
    _validateCodeBtn.layer.borderWidth = 0.5;
    _validateCodeBtn.layer.cornerRadius = 3;
    _validateCodeBtn.clipsToBounds = YES;
    
    
}
- (void)setTextfiledValue:(UITextField *)view {
    view.delegate = self;
    [view setValue:[UIColor colorWithHexString:@"5a6d83"] forKeyPath:@"_placeholderLabel.textColor"];
    //设置文字内容显示位置
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    view.leftView = paddingView;
    view.leftViewMode = UITextFieldViewModeAlways;
    
    view.textColor = [UIColor colorWithHexString:@"9cc3eb"];
    
}
- (IBAction)sendVilidateCodeBtnClick:(id)sender {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = getValidateCodeUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = _phoneTF.text;
    paramDict[@"time"] = kTimeStamp;
    paramDict[@"flag"] = @"find";
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"获取验证码%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            
            
        }else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            
        }
    
    } failedBlock:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"获取验证码失败" hideAfterDelay:1.0];
        
        
    }];
    
    
}
- (IBAction)pswSecurityBtnClick:(id)sender {
    
    _pswSecurityBtn.selected = !_pswSecurityBtn.selected;
    _pswTF.secureTextEntry = !_pswSecurityBtn.selected;
    
    
}
- (IBAction)confirmPswSecurityBtnClick:(id)sender {
    
    _confirmPswSecurityBtn.selected = !_confirmPswSecurityBtn.selected;
    _confirmPswTF.secureTextEntry = !_confirmPswSecurityBtn.selected;
    
}
- (IBAction)modifyBtnClick:(id)sender {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = findPswUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = _phoneTF.text;
    paramDict[@"code"] = _validateCodeTF.text;
    paramDict[@"password"] = _pswTF.text;
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"修改密码%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            
            [self addSuccessView];
            
            
            
        }else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            
        }
        
        
    } failedBlock:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"修改密码失败" hideAfterDelay:1.0];
        
        
    }];
    
    
    
    
   
    
}
- (void)addSuccessView {
    
    //修改成功
    UIView * successView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    successView.backgroundColor = [UIColor colorWithHexString:@"323842"];
    [self.view addSubview:successView];
    
    UIImageView * successImgView = [[UIImageView alloc] init];
    successImgView.image = [UIImage imageNamed:@"iconfont-login-64chenggong"];
    [successView addSubview:successImgView];
    [successImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successView);
        make.top.offset(200);
        make.width.height.offset(70);
    }];
    
    UILabel * stateLab = [[UILabel alloc] init];
    stateLab.text = @"密码修改成功,请重新登录!";
    stateLab.font = [UIFont systemFontOfSize:20];
    stateLab.textColor = [UIColor colorWithHexString:@"9cc3eb"];
    [successView addSubview:stateLab];
    [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successView);
        make.top.equalTo(successImgView.mas_bottom).offset(30);
    }];
    
    UILabel * jumpLab = [[UILabel alloc] init];
    jumpLab.font = [UIFont systemFontOfSize:15];
    jumpLab.text = @"自动跳转中...";
    jumpLab.textColor = [UIColor colorWithHexString:@"9cc3eb"];
    jumpLab.alpha = 0.5;
    [successView addSubview:jumpLab];
    [jumpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(successView);
        make.top.equalTo(stateLab.mas_bottom).offset(15);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)setupNav {
    self.title = @"忘记密码";

    [self setLeftText:nil textColor:nil ImgPath:@"iconfont-login-back-copy" action:@selector(backBtnClick)];
    
    [self setTitleText:@"忘记密码" textColor:[UIColor colorWithHexString:@"9cc3eb"]];
    
    
}
- (void)backBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
