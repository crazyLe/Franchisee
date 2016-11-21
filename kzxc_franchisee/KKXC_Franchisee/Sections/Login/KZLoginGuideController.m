//
//  KZLoginGuideController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZLoginGuideController.h"
#import "KZLoginController.h"
#import "KZRegisterController.h"
#import "FLAnimatedImage.h"

@interface KZLoginGuideController ()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animationLogo;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation KZLoginGuideController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"animationLogo" ofType:@"gif"];
    NSData *gifData = [[NSData alloc] initWithContentsOfFile:gifPath];
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    self.animationLogo.animatedImage = gifImage;
    
    [self createUI];
    
}
- (void)createUI {
    
    _registerBtn.layer.borderWidth = 1;
    _registerBtn.layer.borderColor = [UIColor colorWithHexString:@"9cc3eb"].CGColor;
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)loginBtnClick:(id)sender {
    KZLoginController * loginCtl = [[KZLoginController alloc] init];
    [self.navigationController pushViewController:loginCtl animated:YES];
}

- (IBAction)registerBtnClick:(id)sender {
    
    KZRegisterController * registerCtl = [[KZRegisterController alloc] init];
    [self.navigationController pushViewController:registerCtl animated:YES];
    
}

@end
