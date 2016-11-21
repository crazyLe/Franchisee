//
//  KZMaterialListController.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZApplyCommitController.h"
#import "UIViewController+Refresh.h"
#import "KZMaterialListCell.h"
#import "KZMaterialListController.h"

@interface KZMaterialListController () <KZMaterialListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KZMaterialListController
{
    
}

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    [self setUI];
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText:@"物料清单" textColor:nil];
}

- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    [self setScroll:_tableView networkAdd:kMyMaterialListInterface paraDic:@{} pageFiledName:@"page" parseDicKeyArr:@[@"data"] parseModelName:@"KZMyMaterialModel"];
    [self refreshScroll];
    [self registerNibWithClassNameArr:@[@"KZMaterialListCell"] cellIdentifier:nil table:_tableView];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KZMaterialListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZMaterialListCell"];
    cell.delegate = self;
    cell.model = self.contentArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - KZMaterialListCellDelegate

- (void)KZMaterialListCell:(KZMaterialListCell *)cell clickBottomBtn:(UIButton *)bottomBtn
{
    int state = [cell.model.state intValue];
    if (state==0) {
        //审核中,撤销
        [self requestUndoWithModel:cell.model];
    } else if(state==2){
        //未通过,重新提交
        KZApplyCommitController *applyCommitVC = [[KZApplyCommitController alloc] init];
        applyCommitVC.materialModelArr = _materialModelArr;
        [self.navigationController pushViewController:applyCommitVC animated:YES];
    }
}

#pragma mark - Network 

//申请撤回
- (void)requestUndoWithModel:(KZMyMaterialModel *)model{
    if (isEmptyStr(model.orderId)) {
        NSLog(@"check the orderId parameter");
        return;
    }
    [KZNetworkEngine postWithUrl:kApplyUndoInterface paraDic:@{@"order_id":model.orderId} successBlock:^(id jsonObj) {
        if (isEqualValue(jsonObj[@"code"], 1)) {
            //成功撤回
            [[ProgressHUD sharedInstance] showSuccessSVHudWithTitle:@"撤销成功" hideAfterDelay:kHudDismissTime animaton:YES];
            //删除对应数据
            [self.contentArr removeObject:model];
            //刷新表
            [self.tableView reloadData];
        } else {
            [[ProgressHUD sharedInstance] showErrorSVHudWithTitle:@"撤销失败,请稍后重试" hideAfterDelay:kHudDismissTime];
        }
    } failedBlock:^(NSError *error) {
         [[ProgressHUD sharedInstance] showErrorSVHudWithTitle:@"撤销失败,请稍后重试" hideAfterDelay:kHudDismissTime];
    }];
}

@end
