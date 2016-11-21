//
//  KZAddCardController.m
//  KKXC_Franchisee
//
//  Created by sky on 2016/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZAddCardController.h"
#import "KZBindBankInfo.h"

@interface KZAddCardController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cardHolderField;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *cardNumField;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;

@property (weak, nonatomic) IBOutlet UIPickerView *aPickView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickBottomConstraint;

@property (nonatomic, strong) NSArray *banks;

@property (nonatomic, strong) KZBindBankInfo *selectedBank;

//遮盖蒙版
@property (nonatomic, strong) UIView *coverView;

- (IBAction)showPick;
- (IBAction)submitHandle:(UIButton *)sender;

@end

@implementation KZAddCardController

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.35];
        [self.view addSubview:_coverView];
        [self.view bringSubviewToFront:_aPickView];
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverView:)]];
    }
    return _coverView;
}

- (void)tapCoverView:(UITapGestureRecognizer *)tap{
    //隐藏蒙版
    [self dismissCoverView];
    //隐藏PickerView
    [self dismissPickerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"添加银行卡";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.banks.count == 0) {
        [self requestBanks];
    }
}

- (void)requestBanks {
    NSString * url = kGetBanksUrl;
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    [KZNetworkEngine postWithUrl:url paraDic:nil successBlock:^(id jsonObj) {
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString *msg = jsonObj[@"msg"];
        NSArray *bankArray = jsonObj[@"data"];
        NSLog(@"card>>%@",bankArray);

        if (code == 1) {
            [self.hudManager dismissSVHud];
            self.banks = [KZBindBankInfo mj_objectArrayWithKeyValuesArray:bankArray];
            [self.aPickView reloadAllComponents];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"网络异常" hideAfterDelay:1.0];
    }];
}

- (IBAction)showPick {
    
    [self.view endEditing:YES];
    
    //显示蒙版
    [self showCoverView];
    
    if (self.banks.count > 0) {
        [self changePickerVisible:YES];
    } else {
        [self requestBanks];
        [self changePickerVisible:NO];
    }
}

- (IBAction)submitHandle:(UIButton *)sender {
    
    if (_cardHolderField.text.length == 0) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写持卡人姓名" hideAfterDelay:1.0];
        return;
    }
    if (!_selectedBank) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择开户银行" hideAfterDelay:1.0];
        return;
    }
    if (![ValidateHelper validateCardNo:_cardNumField.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写正确的银行卡号" hideAfterDelay:1.0];
        return;
    }
    if (![ValidateHelper validateMobile:_phoneNumField.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写正确的手机号" hideAfterDelay:1.0];
        return;
    }

    NSString * url = kBindBankCardUrl;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = self.phoneNumField.text;
    paramDict[@"bank_id"] = self.selectedBank.bankId;
    paramDict[@"bank_name"] = self.selectedBank.bankName;
    paramDict[@"card_num"] = self.cardNumField.text;

    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString *msg = jsonObj[@"msg"];
        NSDictionary *bankDic = jsonObj[@"data"];
        NSLog(@"card>>%@",bankDic);

        if (code == 1) {
            [self.hudManager dismissSVHud];
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:kBindCardSucceedNotification object:nil];
            [self bindSucceedHandle];
            
            [curDefaults setObject:@(YES) forKey:@"kBindState"];
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"网络异常" hideAfterDelay:1.0];
    }];
}

- (void)bindSucceedHandle {
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"绑定成功 ！"
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertCtl addAction:sureAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)changePickerVisible:(BOOL)visible {
    if (visible) {
        [self showPickerView];
    } else {
        [self dismissPickerView];
    }
}

/**
 显示PickerView
 */
- (void)showPickerView{
    self.pickBottomConstraint.constant = 0;
}

/**
 隐藏PickerView
 */
- (void)dismissPickerView{
    self.pickBottomConstraint.constant = -220;
}

/**
 显示蒙版
 */
- (void)showCoverView{
    self.coverView.hidden = NO;
}

/**
 隐藏蒙版
 */
- (void)dismissCoverView{
    self.coverView.hidden = YES;
}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self changePickerVisible:NO];
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.banks.count;
}

#pragma mark -- UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 25;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    KZBindBankInfo *bank = self.banks[row];
    return bank.bankName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    KZBindBankInfo *bank = self.banks[row];
    self.bankNameLabel.text = bank.bankName;
    self.selectedBank = bank;
}

@end
