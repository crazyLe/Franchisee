//
//  KZMineController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "User.h"
#import "KZMineController.h"
#import "KZMyCardController.h"
#import "KZAboutController.h"
#import "KZFeedbackController.h"
#import "KZPersonSetController.h"
#import "KZAccountSecurityController.h"
#import "KZIntentionRemarksController.h"
#import "KZLoginGuideController.h"
#import "KZMineCell.h"

static NSString *const kKZMineCellID = @"KZMineCell";

@interface KZMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *mineTable;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

- (IBAction)editAction;

@end

@implementation KZMineController

#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";

    [self configTableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30/255.0 green:136/255.0 blue:218/255.0 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self loadPersonData];
}

- (void)configTableView {
    self.mineTable.tableHeaderView = self.headerView;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 40;
    self.avatarImageView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.2].CGColor;
    self.avatarImageView.layer.borderWidth = 4;

    self.editButton.layer.borderWidth = 1;
    self.editButton.layer.borderColor = [UIColor colorWithHexString:@"#7abeec"].CGColor;

    [self.mineTable registerNib:[UINib nibWithNibName:@"KZMineCell" bundle:nil] forCellReuseIdentifier:kKZMineCellID];
}

- (void)loadPersonData {
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中" hideAfterDelay:10.0];
    [KZNetworkEngine postWithUrl:getPersonSetDataUrl paraDic:nil successBlock:^(id jsonObj) {
        [self.hudManager dismissSVHud];
        int code = [jsonObj[@"code"] intValue];
        if (1 == code) {
            NSDictionary *dict = jsonObj[@"data"];
            [kUserDefault setValue:dict[@"userName"] forKey:@"nickName"];
            [kUserDefault setValue:dict[@"userFace"] forKey:@"face"];
            NSString *nickName = ([dict[@"userName"] length] == 0)?@"未设置":dict[@"userName"];
            self.nickLabel.text = nickName;
            [self.avatarImageView sd_setImageWithURL:dict[@"userFace"] placeholderImage:[UIImage imageNamed:@"placeHeader"]];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager dismissSVHud];
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KZMineCell *cell = [tableView dequeueReusableCellWithIdentifier:kKZMineCellID forIndexPath:indexPath];
    NSString *iconName =  @[@"icon_mine_card",@"icon_mine_security",@"icon_mine_about",@"icon_mine_feedback"][indexPath.row];
    cell.leftIcon.image = [UIImage imageNamed:iconName];
    cell.showMessage.text = @[@"绑定银行卡",@"账号安全",@"关于康庄",@"意见反馈"][indexPath.row];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 56;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor colorWithHexString:@"E94E4E"] forState:UIControlStateNormal];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(loginout) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];

    UIEdgeInsets padding = UIEdgeInsetsMake(10, 0, 0, 0);
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView).with.insets(padding);
        make.height.equalTo(@46);
    }];

    return footerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;

    switch (row) {
        //绑定银行卡
        case 0: {
            KZMyCardController *myCardCtl = [[KZMyCardController alloc] initWithNibName:@"KZMyCardController" bundle:nil];
            [self.navigationController pushViewController:myCardCtl animated:YES];
        }
            break;
        //账号安全
        case 1: {
            
            KZAccountSecurityController *security = [[KZAccountSecurityController alloc]init];
            security.isFromGRSZ = YES;
            [self.navigationController pushViewController:security animated:YES];
        }
            break;
        //关于康庄
        case 2: {
            KZAboutController *about = [[KZAboutController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
        //意见反馈
        case 3: {
            KZFeedbackController *feedback = [[KZFeedbackController alloc]init];
            [self.navigationController pushViewController:feedback animated:YES];
            
        }
            break;    
        default:
            break;
    }
}


- (void)loginout {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"退出登录" preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        //清除所有用户信息
        [User clearUserInfo];
        
        KZLoginGuideController *loginGuideCtl = [[KZLoginGuideController alloc] init];
        UINavigationController *rootCtl = [[UINavigationController alloc] initWithRootViewController:loginGuideCtl];
        rootCtl.navigationBar.translucent = NO;
        rootCtl.navigationBar.barTintColor = [UIColor colorWithHexString:@"323842"];
        [rootCtl.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        rootCtl.navigationBar.shadowImage = [[UIImage alloc] init];

        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        window.rootViewController = rootCtl;
    }];
    [alert addAction:sure];

    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:cancle];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- IBAction
- (IBAction)editAction {
    KZPersonSetController *personsetCtl = [[KZPersonSetController alloc]init];
    [self.navigationController pushViewController:personsetCtl animated:YES];
}

@end
