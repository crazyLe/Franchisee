//
//  KZWorkScheduleDoingController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWorkScheduleDoingController.h"
#import "WorkScheduleCell.h"
#import "KZWorkScheduleDetailsController.h"
#import "KZWorkLogController.h"
#import "WorkScheduleModel.h"
#import "UIScrollView+EmptyDataSet.h"

@interface KZWorkScheduleDoingController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

{
    int currentpage;
    NSMutableArray *worksArray;
}

@property(nonatomic,strong)UITableView *table;

@end

@implementation KZWorkScheduleDoingController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    currentpage = 1;
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0,65+44, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _table.rowHeight = 95;
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        currentpage = 1;
        [self loadNetWorkData];
        [_table.mj_header endRefreshing];
    }];
    
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        currentpage ++;
        [self loadNetWorkData];
        [_table.mj_footer endRefreshing];
    }];
    
    [self setupEmptyDataSet];
}

- (void)setupEmptyDataSet {
    _table.emptyDataSetSource = self;
    _table.emptyDataSetDelegate = self;
    
    //这行代码必须加上，可以去除tableView的多余的线，否则会影响美观
    _table.tableFooterView = [UIView new];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_work_zanwugongzuo"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1d8fe1"]};
    return [[NSAttributedString alloc] initWithString:@"暂无工作安排" attributes:attributes];
}

#pragma mark -- DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)loadNetWorkData {
    
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中..." hideAfterDelay:10.0];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"state"] = @"1";
    param[@"page"] = @(currentpage);
    
    [KZNetworkEngine postWithUrl:workScheduleUrl paraDic:param successBlock:^(id jsonObj) {
       
        int code = [jsonObj[@"code"] intValue];
        if (1 == code ) {
            if (1 == currentpage) {
                 [self.hudManager dismissSVHud];
                    NSArray *dictArray = jsonObj[@"data"];
                    worksArray = [WorkScheduleModel mj_objectArrayWithKeyValuesArray:dictArray];
                [_table reloadData];
            } else {
                NSArray *dictArray = jsonObj[@"data"];
                if (dictArray.count == 0) {
                    [self.hudManager showSuccessSVHudWithTitle:@"数据加载完了" hideAfterDelay:1.0 animaton:YES];
                    return ;
                }
                for (NSDictionary *dict in dictArray) {
                    WorkScheduleModel *model = [WorkScheduleModel mj_objectWithKeyValues:dict];
                    
                    [worksArray addObject:model];
                }
                [self.hudManager dismissSVHud];
                [_table reloadData];
            }
        }
    } failedBlock:^(NSError *error) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [_table.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return worksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"WorkScheduleCell";
    
    NSInteger row = indexPath.row;
    
    WorkScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkScheduleCell" owner:nil options:nil] lastObject];
    }
    
    cell.currentStatue = @"doing";
    
    cell.model = worksArray[row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WorkScheduleModel *model = [worksArray objectAtIndex:indexPath.row];
    
    KZWorkScheduleDetailsController *details = [[KZWorkScheduleDetailsController alloc]init];
    details.taskId = model.taskId;
    details.type = @"1";
    
    [self.navigationController pushViewController:details animated:YES];
}


@end
