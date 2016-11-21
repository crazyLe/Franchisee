//
//  KZMessageController.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZPercentageApplyController.h"
#import "KZMaterialListController.h"
#import <UIScrollView+EmptyDataSet.h>
#import "KZMessageManager.h"
#import "KZMessageCell.h"
#import "KZMessageController.h"

@interface KZMessageController () <KZMessageCellDelegate,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation KZMessageController
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
    [self pullMessageAndReadCacheMessage];
}

#pragma mark - Setup

- (void)setNavigation
{
    [self setTitleText:@"系统消息" textColor:nil];
}

- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    [self registerNibWithClassNameArr:@[@"KZMessageCell"] cellIdentifier:nil table:_tableView];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KZMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZMessageCell"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KZMessageModel *model = _dataSource[indexPath.row];
    switch ([model.msg_id intValue]) {
        case 53:case 54:
            //物料审批列表
            {
                KZMaterialListController *materialListVC = [[KZMaterialListController alloc] init];
                [self.navigationController pushViewController:materialListVC animated:YES];
            }
            break;
        case 55:case 56:
            //提成申请列表
            {
                KZPercentageApplyController *percentageApplyVC = [[KZPercentageApplyController alloc] init];
                percentageApplyVC.isShowAlreadyApplyFirst = YES;
                [self.navigationController pushViewController:percentageApplyVC animated:YES];
            }
            break;
        case 57:
            //意向学员
            {
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
            
        default:
            break;
    }
    //设置消息为已读,更新数据库对应记录isRead字段为 @"1"
    [KZMessageManager setMessageAlreadyRead:model];
    [self prepareDataAndReload];
}

#pragma mark - KZMessageCellDelegate

//点击删除按钮
- (void)KZMessageCell:(KZMessageCell *)cell clickDeleteBtn:(UIButton *)deleteBtn{
    //删除本地数据库对应记录
    [KZMessageManager deleteMessage:cell.model];
    //删除行对应数据源
    NSMutableArray *data = [self.dataSource mutableCopy];
    [data removeObjectAtIndex:cell.indexPath.row];
    self.dataSource = data;
    //刷新表
    [_tableView deleteRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        //刷新work角标未读消息显示
        [self refreshWorkBadge];
    });
}

#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate
/*
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    return [NSMutableAttributedString attributeStringWithText:@"暂无数据" attributes:@[kGrayHex99]];
}
*/

#pragma mark 拉取消息，并读取本地缓存消息

- (void)pullMessageAndReadCacheMessage{
    //拉取消息
    [[ProgressHUD sharedInstance] showNormalStateSVHUDWithTitle:@"请稍等..."];
    [KZMessageManager pullNewMessageWithCompletionBlock:^(BOOL isSuccess) {
        //读取本地缓存消息
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[ProgressHUD sharedInstance] dismissSVHud];
            [self prepareDataAndReload];
        });
    }];
}

- (void)prepareDataAndReload{
    self.dataSource = [KZMessageManager readAllMessageFromDB];
    //刷新表
    [_tableView reloadData];
    
    [self refreshWorkBadge];
}

- (void)refreshWorkBadge{
    //通知work页和意向列表页更新未读消息个数
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateWorkBadgeNotification object:nil];
}

@end
