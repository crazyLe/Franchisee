//
//  KZWorkController.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMessageManager.h"
#import "KZWebController.h"
#import "KZMessageController.h"
#import "KZArticleModel.h"
#import "KZWorkModel.h"
#import "BusinessTrainController.h"
#import "KZMaterialsApplyController.h"
#import "KZWorkCollegeCell.h"
#import "KZWorkHeaderCell.h"
#import "KZWorkOfficeCell.h"
#import "KZWorkBannerCell.h"
#import "KZWorkReportCell.h"
#import "KZWorkBaseInfoCell.h"
#import "KZWorkController.h"
#import <JSBadgeView.h>
#import "KZWorkScheduleController.h"
#import "KZDelResonView.h"
#import "KZWeiCardController.h"
#import "KZActivityController.h"
#import "KZPercentageApplyController.h"
#import "KZDIYWheelHeader.h"


@interface KZWorkController () <KZWorkOfficeCellDelegate,KZWorkBaseInfoCellDelegate>

@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) JSBadgeView *badgeView;

@property (nonatomic,strong) UITableView *bg_TableView;

@property (nonatomic,strong) KZWorkModel *workModel;

@end

@implementation KZWorkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"工作";
    
    [self setNavigation];
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageBadge:) name:kUpdateWorkBadgeNotification object:nil];
}

//刷新右上角消息角标
- (void)refreshMessageBadge:(NSNotification *)notify{
    [self setNavRightBadge];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bg_TableView reloadData];
}

#pragma mark - Setup

- (void)setNavigation {
    self.rightBtn = [self setRightText:nil textColor:nil ImgPath:@"iconfont-work-tixing"  action:@selector(clickRightBtn:)];
    
    [self setNavRightBadge];
}

//进入消息中心
- (void)clickRightBtn:(UIButton *)btn {
    KZMessageController *messageVC = [[KZMessageController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)setNavRightBadge {
    if (!self.badgeView) {
        //1、在父控件（parentView）上显示，显示的位置TopRight
        self.badgeView = [[JSBadgeView alloc]initWithParentView:self.rightBtn alignment:JSBadgeViewAlignmentTopRight];
        //2、如果显示的位置不对，可以自己调整，超爽啊！
        self.badgeView.badgePositionAdjustment = CGPointMake(0, 3);
        //1、背景色
        self.badgeView.badgeBackgroundColor = [UIColor redColor];
        //2、没有反光面
        self.badgeView.badgeOverlayColor = [UIColor clearColor];
        //3、外圈的颜色，默认是白色
        self.badgeView.badgeStrokeColor = [UIColor redColor];
    }
    
    /*****设置数字****/
    //1、用字符
    NSArray *unReadMsg = [KZMessageManager queryAllUnReadMessage];
    if (isEmptyArr(unReadMsg)) {
        self.badgeView.badgeText = @"";
        self.badgeView.hidden = YES; //无未读消息，隐藏角标
    } else {
        self.badgeView.badgeText = unReadMsg.count<=99 ? [NSString stringWithFormat:@"%ld",unReadMsg.count] : @"99+";
        self.badgeView.hidden = NO; //有未读消息，显示角标
    }
    //当更新数字时，最好刷新，不然由于frame固定的，数字为2位时，红圈变形
    [self.badgeView setNeedsLayout];
}

- (void)setUI {
    [self setBg_TableView];
}

- (void)setBg_TableView {
    self.bg_TableView = [self setBg_TableViewWithConstraints:nil];
    [self registerNibWithClassNameArr:@[@"KZWorkBaseInfoCell",@"KZWorkReportCell",@"KZWorkBannerCell"
    ,@"KZWorkOfficeCell",@"KZWorkHeaderCell",@"KZWorkCollegeCell"] cellIdentifier:nil table:self.bg_TableView];

    WeakObj(self)
    self.bg_TableView.mj_header = [KZDIYWheelHeader headerWithRefreshingBlock:^{
        [selfWeak networkRequest];
    }];
    [self.bg_TableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?5:_workModel.article.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0?[@[@(235),@(45),@(100),@(250),@(60)][indexPath.row] floatValue]:125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                KZWorkBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZWorkBaseInfoCell"];
                [cell.headBtn sd_setImageWithURL:[NSURL URLWithString:_workModel.userFace] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeHeader"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        [cell.headBtn setImage:[UIImage imageNamed:@"placeHeader"] forState:UIControlStateNormal];
                    }
                }];
                
                cell.delegate = self;
                
                [cell.incomeView setIncomeMoney:0];
//                [cell.incomeView setIncomeMoney:3252.56];
                [cell.incomeView setIncomeMoney:[_workModel.userTotal floatValue]];
                
                [cell.leftCircleView setShowNum:_workModel.customerNum];
                [cell.centerCircleView setShowNum:_workModel.regNum];
                [cell.rightCircleView setShowNum:_workModel.payNum];
                
                return cell;
            }
                break;
            case 1:
            {
                //康庄战报
                KZWorkReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZWorkReportCell"];
                cell.newsContentModelArr = _workModel.news;
                return cell;
            }
                break;
            case 2:
            {
                //banner
                KZWorkBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZWorkBannerCell"];
                cell.bannerModelArr = _workModel.banner;
                return cell;
            }
                break;
            case 3:
            {
                //移动办公
                KZWorkOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZWorkOfficeCell"];
                cell.delegate = self;
                return cell;
            }
                break;
            case 4:
            {
                //康庄学院header
                KZWorkHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZWorkHeaderCell"];
                return cell;
            }
                break;
            default:
                break;
        }
    } else {
        //康庄学院
        KZWorkCollegeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZWorkCollegeCell"];
        cell.articleModel = _workModel.article[indexPath.row];
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        KZArticleModel *articleModel = _workModel.article[indexPath.row];
        KZWebController *webVC = [[KZWebController alloc] init];
        webVC.webURL = [kWorkArticleInterface stringByAppendingPathComponent:articleModel.articleId];
        webVC.dynamicTitle = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    } else {
        if (indexPath.row==1) {
            //康庄战报
            KZWorkReportCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
        }
    }
}

#pragma mark - KZWorkOfficeCellDelegate

- (void)KZWorkOfficeCell:(KZWorkOfficeCell *)cell clickBtn:(UIButton *)btn;
{
    UIViewController *VC = nil;
    switch (btn.tag) {
        case 10:
        {
            //招生名片
            KZWeiCardController *weicard = [[KZWeiCardController alloc]init];
            [self.navigationController pushViewController:weicard animated:YES];
        }
            break;
        case 11:
        {
            //提成申请
            KZPercentageApplyController * percentageCtl = [[KZPercentageApplyController alloc] init];
            [self.navigationController pushViewController:percentageCtl animated:YES];
            
        }
            break;
        case 12:
        {
            //工作安排
            VC = [[KZWorkScheduleController alloc]init];
        }
            break;
        case 13:
        {
            //活动安排
            KZActivityController *activity = [[KZActivityController alloc]init];
            [self.navigationController pushViewController:activity animated:YES];
            
        }
            break;
        case 14:
        {
            //业务培训
            VC = [[BusinessTrainController alloc] init];
        }
            break;
        case 15:
        {
            //物料申请
            VC = [[KZMaterialsApplyController alloc] init];
        }
            break;
            
        default:
            break;
    }
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - KZWorkBaseInfoCellDelegate

//跳转如何赚钱web
- (void)KZWorkBaseInfoCell:(KZWorkBaseInfoCell *)cell clickHowEarnBtn:(UIButton *)howEarnBtn{
    KZWebController *webVC = [[KZWebController alloc] init];
    webVC.webURL = kWorkHowEarnMoney;
    webVC.dynamicTitle = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Network

- (void)networkRequest{
    [KZNetworkEngine postWithUrl:kWorkInterface paraDic:@{} successBlock:^(id jsonObj) {
        if (isEqualValue(jsonObj[@"code"], 1)) {
            //成功
            _workModel = [KZWorkModel mj_objectWithKeyValues:jsonObj[@"data"]];
            [self.bg_TableView reloadData];
        } else {
            
        }
        [self.bg_TableView.mj_header endRefreshing];
    } failedBlock:^(NSError *error) {
        [self.bg_TableView.mj_header endRefreshing];
    }];
}

@end
