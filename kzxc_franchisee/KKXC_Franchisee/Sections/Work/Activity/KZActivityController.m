//
//  KZActivityController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZActivityController.h"
#import "KZActivityDetailController.h"
#import "KZActivityCell.h"
#import "ActivityModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *const kKZActivityCellID = @"KZActivityCell";

@interface KZActivityController () <UITableViewDelegate,UITableViewDataSource, DZNEmptyDataSetSource>
{
    int currentpage;
    NSMutableArray *worksArray;
}

@property (weak, nonatomic) IBOutlet UITableView *aTableView;


@end

@implementation KZActivityController
#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"活动宣传";

    currentpage = 1;
    [self configTableView];
    [self loadNetWorkData];
}

- (void)configTableView {
    [self.aTableView registerNib:[UINib nibWithNibName:@"KZActivityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kKZActivityCellID];
#pragma todo -- header footer
}

- (void)loadNetWorkData {
    
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中..." hideAfterDelay:10.0];
    
    [KZNetworkEngine postWithUrl:workActivityUrl paraDic:nil successBlock:^(id jsonObj) {
        
        int code = [jsonObj[@"code"] intValue];
        NSString *msg = jsonObj[@"msg"];
        
        if (1 == code ) {
            [self.hudManager dismissSVHud];
            NSArray *dictArray = jsonObj[@"data"];
            worksArray = [ActivityModel mj_objectArrayWithKeyValuesArray:dictArray];
            [self.aTableView reloadData];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager dismissSVHud];
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return worksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    KZActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kKZActivityCellID forIndexPath:indexPath];

    
    cell.model = worksArray[row];
    
    return cell;
}

- (void)configureCell:(KZActivityCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"

    cell.model = worksArray[indexPath.row];
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kKZActivityCellID configuration:^(KZActivityCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityModel *activity = worksArray[indexPath.row];
    
    KZActivityDetailController *activityDetailCtl = [[KZActivityDetailController alloc] init];
    NSString *detailURL = [WAP_HOST_ADD stringByAppendingFormat:@"/activity/show/%@?franchisee_id=%@&app=1",activity.activityId,kUid];
    activityDetailCtl.webURL = detailURL;
    activityDetailCtl.activity = activity;

    [self.navigationController pushViewController:activityDetailCtl animated:YES];
}

#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"img_work_emptyActivity"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无活动，敬请期待";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
