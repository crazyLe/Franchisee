//
//  KZIntentionListController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMessageManager.h"
#import "KZIntentionListController.h"
#import "KZNewIntentionCell.h"
#import "KZIntentionRemarksController.h"
#import "KZDelResonView.h"
#import "KZIntentionListModel.h"
#import <JSBadgeView.h>
#import "KZMessageController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>

@interface KZIntentionListController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,KZNewIntentionCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    
    NSString * _customerNumToday; //今日新增
    NSString * _customerNum; //累计数量
    NSString * _regNum; //注册数量
    NSString * _nofollowNum; //未跟进数据
    NSString * _curlfollowNum; //跟进中数据
    
}

@property (weak, nonatomic) IBOutlet UIButton *descriptionBtn;
@property (weak, nonatomic) IBOutlet UILabel *todayIncreaseLab;
@property (weak, nonatomic) IBOutlet UILabel *totalPersonLab;
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIButton *newwIntentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *followingBtn;
@property (weak, nonatomic) IBOutlet UIView *newwIntentionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UITableView * newwIntentionTable;
@property (nonatomic, strong) UITableView * followingTable;
@property (nonatomic, strong) NSMutableArray * newwIntentionArray;
@property (nonatomic, strong) NSMutableArray * followingArray;
@property (nonatomic, assign) int newIntentionPage;
@property (nonatomic, assign) int followingPage;
@property (nonatomic, assign) NSInteger deleteNewIntentionIndexPath;
@property (nonatomic, assign) NSInteger deleteFollowingIndexPath;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) JSBadgeView *badgeView;
@property (nonatomic, strong) KZDelResonView *delReson;

@property (strong, nonatomic) IBOutlet UIView *topView;

@end

@implementation KZIntentionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"意向列表";
    
    _newwIntentionArray = [NSMutableArray array];
    _followingArray = [NSMutableArray array];
    
    [self setNavigation];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFollowing:) name:@"deleteFollowing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageBadge:) name:kUpdateWorkBadgeNotification object:nil];
}

//刷新右上角消息角标
- (void)refreshMessageBadge:(NSNotification *)notify{
    [self setNavRightBadge];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 新意向的接口
- (void)requestNewIntentionData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    NSString * url = intentionListUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"state"] = @"0";
    paramDict[@"page"] = @(_newIntentionPage);
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"新意向的列表%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            
            NSDictionary * dataDict = jsonObj[@"data"];
            NSArray * customerArray = dataDict[@"customer"];
            _newwIntentionArray = [KZIntentionListModel mj_objectArrayWithKeyValuesArray:customerArray];
            
            //页面的一些单个数据
            _customerNumToday = dataDict[@"customerNumToday"];
            _customerNum = dataDict[@"customerNum"];
            _regNum = dataDict[@"regNum"];
            _nofollowNum = dataDict[@"nofollowNum"];
            _curlfollowNum = dataDict[@"curlfollowNum"];
            
            [self fillData];
            [_newwIntentionTable reloadData];
            [_followingTable reloadData];
            [_newwIntentionTable.mj_header endRefreshing];
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [_newwIntentionTable.mj_header endRefreshing];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_newwIntentionTable.mj_header endRefreshing];
    }];
}

- (void)requestMoreNewIntentionData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    NSString * url = intentionListUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"state"] = @"0";
    paramDict[@"page"] = @(_newIntentionPage);
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        NSLog(@"新意向的列表%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            
            NSDictionary * dataDict = jsonObj[@"data"];
            NSArray * customerArray = dataDict[@"customer"];
            NSArray * array = [KZIntentionListModel mj_objectArrayWithKeyValuesArray:customerArray];
            [_newwIntentionArray addObjectsFromArray:array];
            
            [_newwIntentionTable reloadData];
            [_newwIntentionTable.mj_footer endRefreshing];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [_newwIntentionTable.mj_footer endRefreshing];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_newwIntentionTable.mj_footer endRefreshing];
    }];
}

//填充数据
- (void)fillData {
    _todayIncreaseLab.text = _customerNumToday;
    _totalPersonLab.text = [NSString stringWithFormat:@"累计:%@人    %@人注册APP",_customerNum,_regNum];
}

- (void)createUI {
    
    _roundView.layer.cornerRadius = 135/2;
    _roundView.clipsToBounds = YES;
    _roundView.layer.borderColor = [UIColor colorWithHexString:@"f1f5f8"].CGColor;
    _roundView.layer.borderWidth = 4;
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth*2, 100);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.scrollEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    
    [_newwIntentionBtn setBackgroundImage:[UIImage imageNamed:@"applyBgEffect"] forState:UIControlStateSelected];
    [_newwIntentionBtn setTitleColor:[UIColor colorWithHexString:@"1d8fe1"] forState:UIControlStateSelected];
    [_newwIntentionBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    _newwIntentionBtn.selected = YES;
    [_newwIntentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth/2);
        make.left.offset(0);
        make.centerY.equalTo(_newwIntentionView);
        make.height.equalTo(_newwIntentionView);
    }];
    
    [_followingBtn setBackgroundImage:[UIImage imageNamed:@"applyBgEffect"] forState:UIControlStateSelected];
    [_followingBtn setTitleColor:[UIColor colorWithHexString:@"1d8fe1"] forState:UIControlStateSelected];
    [_followingBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [_followingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth/2);
        make.right.offset(0);
        make.centerY.equalTo(_newwIntentionView);
        make.height.equalTo(_newwIntentionView);
    }];
    
    _newwIntentionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 64) style:UITableViewStyleGrouped];
    _newwIntentionTable.dataSource = self;
    _newwIntentionTable.delegate = self;
    _newwIntentionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _newwIntentionTable.emptyDataSetSource = self;
    _newwIntentionTable.emptyDataSetDelegate = self;
    [_scrollView addSubview:_newwIntentionTable];
    [_newwIntentionTable registerNib:[UINib nibWithNibName:@"KZNewIntentionCell" bundle:nil] forCellReuseIdentifier:@"KZNewIntentionCell"];
    __weak typeof(self) weakSelf = self;
    _newwIntentionTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.newIntentionPage = 1;
        [weakSelf requestNewIntentionData];
        
    }];
    [_newwIntentionTable.mj_header beginRefreshing];
    
    _newwIntentionTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.newIntentionPage ++;
        [weakSelf requestMoreNewIntentionData];
    }];
    
    _followingTable = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 49 - 64) style:UITableViewStyleGrouped];
    _followingTable.dataSource = self;
    _followingTable.delegate = self;
    _followingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _followingTable.emptyDataSetSource = self;
    _followingTable.emptyDataSetDelegate = self;
    [_scrollView addSubview:_followingTable];
    [_followingTable registerNib:[UINib nibWithNibName:@"KZNewIntentionCell" bundle:nil] forCellReuseIdentifier:@"KZNewIntentionCell"];
    _followingTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.followingPage = 1;
        [weakSelf requestFollowingData];
    }];
    [_followingTable.mj_header beginRefreshing];
    
    _followingTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.followingPage ++;
        [weakSelf requestMoreFollowingData];
    }];
}

#pragma mark -- 跟进中的接口
- (void)requestFollowingData {
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = intentionListUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"state"] = @"2";
    paramDict[@"page"] = @(_followingPage);
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"跟进中列表%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            
            NSDictionary * dataDict = jsonObj[@"data"];
            NSArray * customerArray = dataDict[@"customer"];
            _followingArray = [KZIntentionListModel mj_objectArrayWithKeyValuesArray:customerArray];
            
            [_followingTable reloadData];
            [_followingTable.mj_header endRefreshing];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [_followingTable.mj_header endRefreshing];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_followingTable.mj_header endRefreshing];
    }];
}

- (void)requestMoreFollowingData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = intentionListUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"state"] = @"2";
    paramDict[@"page"] = @(_followingPage);
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        NSLog(@"跟进中列表%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            
            NSDictionary * dataDict = jsonObj[@"data"];
            NSArray * customerArray = dataDict[@"customer"];
            NSArray * array = [KZIntentionListModel mj_objectArrayWithKeyValuesArray:customerArray];
            [_followingArray addObjectsFromArray:array];
            
            [_followingTable reloadData];
            [_followingTable.mj_footer endRefreshing];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [_followingTable.mj_footer endRefreshing];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_followingTable.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _newwIntentionTable) {
        return _newwIntentionArray.count;
    } else {
        return _followingArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _newwIntentionTable) {
        
        
        static NSString * identifier = @"KZNewIntentionCell";
        KZNewIntentionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        KZIntentionListModel * intentionModel = _newwIntentionArray[indexPath.row];
        [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:intentionModel.userFace] placeholderImage:[UIImage imageNamed:@"iconfont-Intentionlist-touxiang"]];
        cell.nameLab.text = intentionModel.userName;
        if ([intentionModel.userId isEqualToString:@"0"]) {
            cell.registerStateLab.text = @"未注册";
            cell.registerStateLab.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
        }
        cell.timeLab.text = [self getStamptimeWithString:intentionModel.addTime andSec:4];
        
        cell.customer_id = intentionModel.customerId;
        cell.customer_name = intentionModel.userName;
        
        cell.delegate = self;
        
        cell.edit = ^(KZNewIntentionCell *cell){
            KZIntentionRemarksController *remark = [[KZIntentionRemarksController alloc]init];
            remark.customerId = cell.customer_id;
            remark.name = cell.customer_name;
            [self.navigationController pushViewController:remark animated:YES];
        };
        
        return cell;
        
    } else {
        
        static NSString * identifier = @"KZNewIntentionCell";
        KZNewIntentionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        KZIntentionListModel * intentionModel = _followingArray[indexPath.row];
        [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:intentionModel.userFace] placeholderImage:[UIImage imageNamed:@"iconfont-Intentionlist-touxiang"]];
        cell.nameLab.text = intentionModel.userName;
        if ([intentionModel.userId isEqualToString:@"0"]) {
            cell.registerStateLab.text = @"未注册";
            cell.registerStateLab.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
        }
        cell.timeLab.text = [self getStamptimeWithString:intentionModel.addTime andSec:4];
        
        cell.customer_id = intentionModel.customerId;
        cell.customer_name = intentionModel.userName;
        
        cell.delegate = self;
        
        cell.edit = ^(KZNewIntentionCell *cell){
            KZIntentionRemarksController *remark = [[KZIntentionRemarksController alloc]init];
            remark.customerId = intentionModel.customerId;
            remark.name = cell.customer_name;
            [self.navigationController pushViewController:remark animated:YES];
        };
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30+200+10+50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerBgView = [UIView new];
    
    if (tableView == _newwIntentionTable) {
        
        if (!_newwIntentionBtn.selected) {
            return headerBgView;
        }
    } else {
        if (!_followingBtn.selected) {
            return headerBgView;
        }
    }
    
    [headerBgView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 30, 0));
    }];
    
    
    if (tableView == _newwIntentionTable) {
        
        if (!_newwIntentionBtn.selected) {
            
        }
        
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"f6f9fb"];
        
        NSMutableAttributedString * attString = [NSMutableAttributedString attributeStringWithText:@"您还有" attributes:@[Font13,[UIColor colorWithHexString:@"666666"]]];
        [attString appendText:_nofollowNum withAttributesArr:@[Font13,[UIColor colorWithHexString:@"1d8fe1"]]];
        [attString appendText:@"个意向学员未跟进,加油哦!" withAttributesArr:@[Font13,[UIColor colorWithHexString:@"666666"]]];

        
        UILabel * descriptionLab = [[UILabel alloc] init];
        descriptionLab.attributedText = attString;
        [bgView addSubview:descriptionLab];
        [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bgView);
        }];
        
        [headerBgView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(30);
        }];

    } else {
        
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"f6f9fb"];
        
        NSMutableAttributedString * attString = [NSMutableAttributedString attributeStringWithText:@"您还有" attributes:@[Font13,[UIColor colorWithHexString:@"666666"]]];
        [attString appendText:_curlfollowNum withAttributesArr:@[Font13,[UIColor colorWithHexString:@"1d8fe1"]]];
        [attString appendText:@"个意向学员正在跟进,加油哦!" withAttributesArr:@[Font13,[UIColor colorWithHexString:@"666666"]]];
        

        UILabel * descriptionLab = [[UILabel alloc] init];
        descriptionLab.attributedText = attString;
        [bgView addSubview:descriptionLab];
        [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bgView);
        }];
        
        [headerBgView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(30);
        }];
    }
    
    return headerBgView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (tableView == _newwIntentionTable) {
           
            _deleteNewIntentionIndexPath = indexPath.row;
            
            UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil
                                                                              message:@"确认删除该意向用户?"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self deleteIntentionUserData];
            }];
            [alertCtl addAction:cancleAction];
            [alertCtl addAction:sureAction];
            [self presentViewController:alertCtl animated:YES completion:nil];
        }
        if (tableView == _followingTable) {
            
            _deleteFollowingIndexPath = indexPath.row;
            
            _delReson = [[KZDelResonView alloc]init];
            [_delReson show];
        }
    }
}

- (IBAction)newwIntentionBtnClick:(id)sender {
    _newwIntentionBtn.selected = YES;
    _followingBtn.selected = NO;
    [_newwIntentionTable reloadData];
    _newwIntentionTable.contentOffset = _followingTable.contentOffset;
    [_scrollView setContentOffset:CGPointZero animated:NO];
}

- (IBAction)followingBtnClick:(id)sender {
    _newwIntentionBtn.selected = NO;
    _followingBtn.selected = YES;
    [_followingTable reloadData];
    _followingTable.contentOffset = _newwIntentionTable.contentOffset;
    [_scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
}

- (IBAction)descriptionBtnClick:(id)sender {
    _bgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgView.backgroundColor =  [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    [_bgView addSubview:_descriptionView];
    [_descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bgView);
        make.width.offset(kScreenWidth - 80);
        make.height.offset(240);
    }];
}

- (IBAction)closeBtnClick:(id)sender {
    [_bgView removeFromSuperview];
}

- (void)KZNewIntentionCellCallPhoneBtn:(UIButton *)btn {
    
    KZNewIntentionCell *cell = (KZNewIntentionCell *)btn.superview.superview;
    NSIndexPath *indexPath = [_newwIntentionTable indexPathForCell:cell];
    NSString *phoneString = nil;
    if (_scrollView.contentOffset.x == 0 ) {
        KZIntentionListModel *intentionModel = _newwIntentionArray[indexPath.row];
        phoneString = intentionModel.userTel;
    } else {
        KZIntentionListModel *intentionModel = _followingArray[indexPath.row];
        phoneString = intentionModel.userTel;
    }
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:phoneString
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *tel = [NSString stringWithFormat:@"tel://%@",phoneString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }];
    [alertCtl addAction:cancleAction];
    [alertCtl addAction:sureAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

#pragma mark -- 新意向列表删除的接口
- (void)deleteIntentionUserData {
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = deleteIntentionUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    KZIntentionListModel * intentionModel = _newwIntentionArray[_deleteNewIntentionIndexPath];
    paramDict[@"customer_id"] = intentionModel.customerId;
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        NSLog(@"新意向的意向删除%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            
            int notFollowNum = [_nofollowNum intValue] - 1;
            _nofollowNum = [NSString stringWithFormat:@"%d",notFollowNum];
            [_newwIntentionArray removeObjectAtIndex:_deleteNewIntentionIndexPath];
            [_newwIntentionTable reloadData];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"删除失败" hideAfterDelay:1.0];
    }];
}

#pragma mark -- 跟进中列表删除的接口
- (void)deleteFollowing:(NSNotification *)text {
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = deleteIntentionUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    KZIntentionListModel * intentionModel = _followingArray[_deleteFollowingIndexPath];
    paramDict[@"customer_id"] = intentionModel.customerId;
    paramDict[@"delReason"] = text.userInfo[@"keyDelete"];
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"跟进中的意向删除%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            
            int curlfollowNum = [_curlfollowNum intValue] - 1;
            _curlfollowNum = [NSString stringWithFormat:@"%d",curlfollowNum];
            [_followingArray removeObjectAtIndex:_deleteFollowingIndexPath];
            [_followingTable reloadData];
            
            [_delReson hide];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"删除失败" hideAfterDelay:1.0];
    }];
}

- (void)setNavigation {
    self.rightBtn = [self setRightText:nil textColor:nil ImgPath:@"iconfont-work-tixing"  action:@selector(clickRightBtn:)];
    [self setNavRightBadge];
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

//进入消息中心
- (void)clickRightBtn:(UIButton *)btn {
    KZMessageController *messageVC = [[KZMessageController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark -- DZNEmptyDataSet的代理方法
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (scrollView == _newwIntentionTable) {
        return [UIImage imageNamed:@"iconfont-ticheng-kong1"];
    } else {
        return [UIImage imageNamed:@"iconfont-ticheng-kong2"];
    }
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (scrollView == _newwIntentionTable) {
        NSString *text = @"分享自己的微名片,快速赚取收入";
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];

    } else {
        NSString *text = @"还没有收益,赶紧去分享";
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1d8fe1"]};

    return [[NSAttributedString alloc] initWithString:@"立即分享->" attributes:attributes];
}

//设置无数据垂直方向显示偏移
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return 140;
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    //显示分享面板
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        NSLog(@"sssss");
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"康庄学车加盟商端" descr:@"康庄学车加盟商端" thumImage:[UIImage imageNamed:@"share"]];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:kWeiGuanWangShareUrl,kUid,[kCityInfo intValue]];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        [weakSelf shareToPlatform:platformType messageObject:messageObject];
    }];
}

#pragma mark -- DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)shareToPlatform:(UMSocialPlatformType)platformType messageObject:(UMSocialMessageObject *)messageObject {
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (!error) {
            [self.hudManager showSuccessSVHudWithTitle:@"分享成功" hideAfterDelay:1.0 animaton:YES];
        } else {
            [self.hudManager showErrorSVHudWithTitle:@"分享失败" hideAfterDelay:1.0];
        }
    }];
}


@end
