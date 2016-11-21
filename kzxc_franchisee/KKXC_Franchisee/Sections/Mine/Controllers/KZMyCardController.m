//
//  KZMyCardController.m
//  KKXC_Franchisee
//
//  Created by sky on 2016/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMyCardController.h"
#import "KZAddCardController.h"
#import "KZMyCardCell.h"
#import "KZBindBankInfo.h"
#import "UIScrollView+EmptyDataSet.h"

static NSString *const kKZMyCardCellID = @"KZMyCardCell";

@interface KZMyCardController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *aTableView;

@property (strong, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic, strong) KZBindBankInfo *bindCard;

@property (nonatomic, strong) NSMutableArray * numberStrSrray;

- (IBAction)bindCardNow;

@end

@implementation KZMyCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"我的银行卡";

    _numberStrSrray = [NSMutableArray array];
    
    [self configTableView];

    [self addNotificationObserver];
    [self requestBankInfo];
}

- (void)addNotificationObserver {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(requestBankInfo) name:kBindCardSucceedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configTableView {
    self.aTableView.sectionHeaderHeight = 18;
    [self.aTableView registerNib:[UINib nibWithNibName:@"KZMyCardCell" bundle:nil] forCellReuseIdentifier:kKZMyCardCellID];
    self.aTableView.emptyDataSetSource = self;
    self.aTableView.emptyDataSetDelegate = self;
}

- (void)requestBankInfo {
    NSString * url = kBankBindInfoUrl;

    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    [KZNetworkEngine postWithUrl:url paraDic:nil successBlock:^(id jsonObj) {
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString *msg = jsonObj[@"msg"];
        NSDictionary *bankDic = jsonObj[@"data"];
        NSLog(@"card>>%@",bankDic);

        if (code == 1) {
            [self.hudManager dismissSVHud];
            self.bindCard = [KZBindBankInfo mj_objectWithKeyValues:bankDic];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        [self.aTableView reloadData];
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"网络异常" hideAfterDelay:1.0];
    }];

}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.bindCard && [self.bindCard.bankId integerValue] != 0) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KZMyCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kKZMyCardCellID forIndexPath:indexPath];
    cell.bankNameLabel.text = self.bindCard.bankName;
//    cell.cardNumLabel.text = self.bindCard.cardNum;
    
    //分割加空格改星号
    NSString *str = self.bindCard.cardNum;
    
    for (int i = (int)str.length - 4 ; i > 0; i-= 4) {
        NSString * fourString =  [str substringWithRange:NSMakeRange(i, 4)];
        if (i != (int)str.length - 4) {
            fourString = @"****";
        }
        [_numberStrSrray addObject:fourString];
    }
    NSString * headString = [str substringToIndex:str.length%4];
    if (headString.length == 3) {
        headString = @"***";
    } else if (headString.length == 2) {
        headString = @"**";
    } else if (headString.length == 1){
        headString = @"*";
    }
    
    [_numberStrSrray addObject:headString];
    
    _numberStrSrray = (NSMutableArray *)[[_numberStrSrray reverseObjectEnumerator] allObjects];
    
    NSString * showString = [_numberStrSrray componentsJoinedByString:@" "];
    
    cell.cardNumLabel.text = showString;

    
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.bindCard && [self.bindCard.bankId integerValue] != 0) {
        return 36;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.bindCard && [self.bindCard.bankId integerValue] != 0) {
        return 86;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.bindCard && [self.bindCard.bankId integerValue] != 0) {

        UIView *footerView = [UIView new];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor colorWithHexString:@"#1D8FE1"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"重新绑定" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(reBindCard) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:button];

        UIEdgeInsets padding = UIEdgeInsetsMake(38, 15, 0, 15);
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footerView).with.insets(padding);
            make.height.equalTo(@46);
        }];

        return footerView;
    }

    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.bindCard && [self.bindCard.bankId integerValue] != 0) {
        UIView *headerView = [UIView new];
        return headerView;
    }
    return nil;
}


- (void)reBindCard {
    KZAddCardController *addCardCtl = [[KZAddCardController alloc] initWithNibName:@"KZAddCardController" bundle:nil];
    [self.navigationController pushViewController:addCardCtl animated:YES];
}


#pragma mark -- DZNEmptyDataSetSource
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return self.emptyView;
}

#pragma mark -- DZNEmptyDataSetDelegate
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -64 - 36;
}

#pragma mark -- IBAction
- (IBAction)bindCardNow {
    KZAddCardController *addCardCtl = [[KZAddCardController alloc] initWithNibName:@"KZAddCardController" bundle:nil];
    [self.navigationController pushViewController:addCardCtl animated:YES];
}
@end
