//
//  KZPercentageApplyController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 2016/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWebController.h"
#import "KZPercentageApplyController.h"
#import "KZNotApplyCell.h"
#import "KZAlreadyApplyCell.h"
#import "KZPercentageModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "KZMyCardController.h"

@interface KZPercentageApplyController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,KZNotApplyCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,KZAlreadyApplyCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentRecruitLab;
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UILabel *currentTotalLab;
@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *yearLab;
@property (weak, nonatomic) IBOutlet UIButton *notApplyBtn;
@property (weak, nonatomic) IBOutlet UIButton *alreadyApplyBtn;
@property (weak, nonatomic) IBOutlet UIView *applyBtnBgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *notApplyTable;
@property (nonatomic, strong) UITableView *alreadyApplyTable;

@property (nonatomic, strong) UIView *calendarView;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, assign) int notApplyPage;
@property (nonatomic, assign) int alreadyApplyPage;
@property (nonatomic, strong) NSMutableArray *notApplyArray;
@property (nonatomic, strong) NSMutableArray *alreadyApplyArray;
@property (nonatomic, copy) NSString *payNumString;
@property (nonatomic, copy) NSString *payNumTodayString;
@property (nonatomic, copy) NSString *selectedDate;


@end

@implementation KZPercentageApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"提成申请";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];

    _notApplyArray = [NSMutableArray array];
    _alreadyApplyArray = [NSMutableArray array];

    [self createUI];
    
    if (_isShowAlreadyApplyFirst) {
        [self alreadyApplyBtnClick:_alreadyApplyBtn];
    }
}

- (void)requestNotApplyData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString *url = percentageApplyUrl;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    paramDict[@"date"] = self.selectedDate;
    paramDict[@"state"] = @"0";
    paramDict[@"page"] = @(_notApplyPage);
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"提成申请未申请%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            NSDictionary * dataDict = jsonObj[@"data"];
            NSArray * cashListArray = dataDict[@"cashList"];
            _notApplyArray = [KZPercentageModel mj_objectArrayWithKeyValuesArray:cashListArray];
            _payNumString = [NSString stringWithFormat:@"%@",dataDict[@"payNum"]] ;
            _payNumTodayString = [NSString stringWithFormat:@"%@",dataDict[@"payNumToday"]];
            
            [self fillData];
            [_notApplyTable reloadData];
            [_notApplyTable.mj_header endRefreshing];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [_notApplyTable.mj_header endRefreshing];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_notApplyTable.mj_header endRefreshing];
    }];
}

- (void)requestMoreNotApplyData {
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = percentageApplyUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"date"] = self.selectedDate;
    paramDict[@"state"] = @"0";
    paramDict[@"page"] = @(_notApplyPage);
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        
        NSLog(@"更多提成申请未申请%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            NSDictionary * dataDict = jsonObj[@"data"];
            NSArray * cashListArray = dataDict[@"cashList"];
            NSArray * array = [KZPercentageModel mj_objectArrayWithKeyValuesArray:cashListArray];
            [_notApplyArray addObjectsFromArray:array];
           
            [_notApplyTable reloadData];
            
            [_notApplyTable.mj_footer endRefreshing];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [_notApplyTable.mj_footer endRefreshing];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_notApplyTable.mj_footer endRefreshing];
    }];
}

- (void)createUI {
    NSString *timeString = [self getYearMonthTime];
    if (!self.selectedDate) {
        self.selectedDate = timeString;
    }
    
    NSArray *dateArray = [timeString componentsSeparatedByString:@"-"];
    _yearLab.text = dateArray.firstObject;
    _monthLab.text = dateArray.lastObject;
    
    [_notApplyBtn setBackgroundImage:[UIImage imageNamed:@"applyBgEffect"] forState:UIControlStateSelected];
    [_notApplyBtn setTitleColor:[UIColor colorWithHexString:@"1d8fe1"] forState:UIControlStateSelected];
    [_notApplyBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    _notApplyBtn.selected = YES;
    [_notApplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth/2);
        make.left.offset(0);
        make.centerY.equalTo(_applyBtnBgView);
    }];
    [_alreadyApplyBtn setBackgroundImage:[UIImage imageNamed:@"applyBgEffect"] forState:UIControlStateSelected];
    [_alreadyApplyBtn setTitleColor:[UIColor colorWithHexString:@"1d8fe1"] forState:UIControlStateSelected];
    [_alreadyApplyBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [_alreadyApplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kScreenWidth/2);
        make.right.offset(0);
        make.centerY.equalTo(_applyBtnBgView);
    }];
    
    _roundView.layer.cornerRadius = 135/2;
    _roundView.clipsToBounds = YES;
    _roundView.layer.borderColor = [UIColor colorWithHexString:@"f1f5f8"].CGColor;
    _roundView.layer.borderWidth = 4;
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth*2, 300);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = NO;
    
    //未申请
    _notApplyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -200 -10 - 50 ) style:UITableViewStylePlain];
    _notApplyTable.dataSource = self;
    _notApplyTable.delegate = self;
    _notApplyTable.emptyDataSetSource = self;
    _notApplyTable.emptyDataSetDelegate = self;
    _notApplyTable.tableFooterView = [UIView new];
    [_scrollView addSubview:_notApplyTable];
    [_notApplyTable registerNib:[UINib nibWithNibName:@"KZNotApplyCell" bundle:nil] forCellReuseIdentifier:@"KZNotApplyCell"];

    __weak typeof(self) weakSelf = self;
    _notApplyTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.notApplyPage = 1;
        [weakSelf requestNotApplyData];
        
    }];
    [_notApplyTable.mj_header beginRefreshing];
    
    _notApplyTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.notApplyPage ++;
        [weakSelf requestMoreNotApplyData];
        
    }];
    
    //已申请
    _alreadyApplyTable = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 -200 -10 - 50 ) style:UITableViewStylePlain];
    _alreadyApplyTable.dataSource = self;
    _alreadyApplyTable.delegate = self;
    _alreadyApplyTable.emptyDataSetSource = self;
    _alreadyApplyTable.emptyDataSetDelegate = self;
    _alreadyApplyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_alreadyApplyTable];
    [_alreadyApplyTable registerNib:[UINib nibWithNibName:@"KZAlreadyApplyCell" bundle:nil] forCellReuseIdentifier:@"KZAlreadyApplyCell"];
    _alreadyApplyTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.alreadyApplyPage = 1;
        [weakSelf requestAlreadyApplyData];
    }];
    [_alreadyApplyTable.mj_header beginRefreshing];
    
    _alreadyApplyTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.alreadyApplyPage ++;
        [weakSelf requestMoreAlreadyApplyData];
    }];
}

- (void)requestAlreadyApplyData {
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = percentageApplyUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"date"] = self.selectedDate;
    paramDict[@"state"] = @"1";
    paramDict[@"page"] = @(_alreadyApplyPage);
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        NSLog(@"提成申请已申请%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            NSDictionary * dataDict = jsonObj[@"data"];
            NSArray * cashListArray = dataDict[@"cashList"];
            
            _alreadyApplyArray = [KZPercentageModel mj_objectArrayWithKeyValuesArray:cashListArray];

            [_alreadyApplyTable reloadData];
            
            [_alreadyApplyTable.mj_header endRefreshing];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [_alreadyApplyTable.mj_header endRefreshing];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_alreadyApplyTable.mj_header endRefreshing];
    }];
}

- (void)requestMoreAlreadyApplyData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@""];
    
    NSString * url = percentageApplyUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"date"] = self.selectedDate;
    paramDict[@"state"] = @"1";
    paramDict[@"page"] = @(_alreadyApplyPage);
    
    [KZNetworkEngine postWithUrl:url paraDic:paramDict successBlock:^(id jsonObj) {
        NSLog(@"更多提成申请已申请%@",jsonObj);
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSString * msg = jsonObj[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            NSDictionary * dataDict = jsonObj[@"data"];
            NSArray * cashListArray = dataDict[@"cashList"];
            NSArray * array = [KZPercentageModel mj_objectArrayWithKeyValuesArray:cashListArray];
            [_alreadyApplyArray addObjectsFromArray:array];
            
            [_alreadyApplyTable reloadData];
            
            [_alreadyApplyTable.mj_footer endRefreshing];
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            [_alreadyApplyTable.mj_footer endRefreshing];
        }
    } failedBlock:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_alreadyApplyTable.mj_footer endRefreshing];
    }];
}

- (void)fillData {
    _currentRecruitLab.text = [NSString stringWithFormat:@"当日招生:%@人",_payNumTodayString];
    _currentTotalLab.text = _payNumString;
}

//点击未申请按钮的方法
- (IBAction)notApplyBtnClick:(id)sender {
    [_scrollView setContentOffset:CGPointZero animated:YES];
    _notApplyBtn.selected = YES;
    _alreadyApplyBtn.selected = NO;
}

//点击未已申请按钮的方法
- (IBAction)alreadyApplyBtnClick:(id)sender {
    [_scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    _notApplyBtn.selected = NO;
    _alreadyApplyBtn.selected = YES;
}

#pragma mark -- tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _notApplyTable) {
        return _notApplyArray.count;
    } else {
        return _alreadyApplyArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _notApplyTable) {
        
        static NSString * identifier = @"KZNotApplyCell";
        KZNotApplyCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        KZPercentageModel * percentageModel = _notApplyArray[indexPath.row];
        cell.nameLab.text = percentageModel.userName;
        cell.timeLab.text = [self getStamptimeWithString:percentageModel.addTime andSec:4];
        cell.typeLab.text = percentageModel.productName;
        cell.priceLab.text = percentageModel.productPrice;
        cell.model = percentageModel;
        cell.delegate = self;
        return cell;
        
    } else {
        
        static NSString * identifier = @"KZAlreadyApplyCell";
        KZAlreadyApplyCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        KZPercentageModel * percentageModel = _alreadyApplyArray[indexPath.row];
        cell.model = percentageModel;
        cell.nameLab.text = percentageModel.userName;
        cell.timeLab.text = [self getStamptimeWithString:percentageModel.addTime andSec:4];
        cell.typeLab.text = percentageModel.productName;
        cell.priceLab.text = percentageModel.productPrice;
        cell.applyMonnyDetailLab.text = [NSString stringWithFormat:@"¥ %@",percentageModel.applyMoney];
        cell.reApplyBtn.hidden = [percentageModel.applyState intValue]!=2;
        int applyState = [percentageModel.applyState intValue];
        if (applyState == 2) {
            //审核失败
            cell.stateLab.text = @"未通过";
            cell.stateLab.textColor = [UIColor colorWithHexString:@"ff801a"];
            if (isEmptyStr(percentageModel.applyStateStr)) {
                cell.stateDetailLab.text = @"";
            } else {
                cell.stateDetailLab.text = [NSString stringWithFormat:@"(原因:%@)",percentageModel.applyStateStr];
            }
        } else if (applyState == 1 || applyState == 3) {
            //1.审核通过 3.确认已转
            cell.stateLab.text = @"已通过";
            cell.stateLab.textColor = [UIColor colorWithHexString:@"1d8fe1"];
            if (isEmptyStr(percentageModel.applyStateStr)) {
                cell.stateDetailLab.text = @"";
            } else {
                cell.stateDetailLab.text = [NSString stringWithFormat:@"(%@)",percentageModel.applyStateStr];
            }
        } else {
            //0.等待审核
            cell.stateLab.text = @"审核中";
            cell.stateLab.textColor = [UIColor colorWithHexString:@"7bcb1e"];
            if (isEmptyStr(percentageModel.applyStateStr)) {
                cell.stateDetailLab.text = @"";
            } else {
                cell.stateDetailLab.text = [NSString stringWithFormat:@"(%@)",percentageModel.applyStateStr];
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _notApplyTable) {
        return 80;
    } else {
        return 130;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KZPercentageModel * percentageModel = _alreadyApplyArray[indexPath.row];
    int applyState = [percentageModel.applyState intValue];
    switch (applyState) {
        case 0:case 1:case 3:
        {
            //跳申请详情wap
            KZWebController *webVC = [[KZWebController alloc] init];
            webVC.webURL = [NSString stringWithFormat:kApplyDetailWapInterface,[kToken stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],percentageModel.orderId];
            webVC.dynamicTitle = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:
        {
            //审核失败
            
        }
            break;
            
        default:
            break;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _scrollView) {
        int page = scrollView.contentOffset.x/kScreenWidth;
        if (page == 0) {
            _notApplyBtn.selected = YES;
            _alreadyApplyBtn.selected = NO;
        } else {
            _notApplyBtn.selected = NO;
            _alreadyApplyBtn.selected = YES;
        }
    }
}

#pragma mark -- DZNEmptyDataSet的代理方法
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (scrollView == _notApplyTable) {
        return [UIImage imageNamed:@"iconfont-ticheng-kong1"];
    } else {
        return [UIImage imageNamed:@"iconfont-ticheng-kong2"];
    }
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (scrollView == _notApplyTable) {
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

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    //显示分享面板
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
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

//点击日历绑定的方法
- (IBAction)calendarBtnClick:(id)sender {
    
    _calendarView = [[UIView alloc] init];
    _calendarView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _calendarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_calendarView];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(kScreenWidth - 60, 30, 30, 30);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_calendarView addSubview:closeBtn];
    
    UILabel * remindLab = [[UILabel alloc] init];
    remindLab.text = @"*仅供查询当月和前9个月";
    remindLab.font = [UIFont systemFontOfSize:16];
    remindLab.textColor = [UIColor colorWithHexString:@"ff801a"];
    [_calendarView addSubview:remindLab];
    [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_calendarView);
        make.top.offset(80);
    }];

    NSDate *mydate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    [adcomps setMonth:0];
    [adcomps setDay:0];

    _timeArray = [NSMutableArray arrayWithCapacity:10];
    NSInteger selectedIndex = 0;
    for (int i = 0; i < 11; i ++) {
        [adcomps setMonth:-i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
        NSString *beforDate = [dateFormatter stringFromDate:newdate];
        if ([beforDate isEqualToString:self.selectedDate]) {
            selectedIndex = i;
        }
        [_timeArray addObject:beforDate];
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.dataSource = self;
    // 设置Delegate代理
    pickerView.delegate = self;
    CALayer * viewLayer = pickerView.layer;
    [viewLayer setFrame:CGRectMake(80, 100, kScreenWidth - 160, 350)];
    [_calendarView addSubview:pickerView];
    
    [pickerView selectRow:selectedIndex inComponent:0 animated:NO];

    UIImageView *effectImgView = [[UIImageView alloc] init];
    effectImgView.image = [UIImage imageNamed:@"selectEffect"];
    [_calendarView addSubview:effectImgView];
    [effectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(pickerView);
        make.width.offset(200);
        make.height.offset(30);
    }];
}

#pragma mark -- pickerView的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *dateString = _timeArray[row];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    if (dateArray.count == 2) {
        dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
        dateString = [dateString stringByAppendingString:@"月"];
    }
    return dateString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *timeString = _timeArray[row];
    self.selectedDate = timeString;
    NSArray *dateArray = [timeString componentsSeparatedByString:@"-"];
    _monthLab.text = dateArray.lastObject;
    _yearLab.text = dateArray.firstObject;;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_calendarView removeFromSuperview];
        [self requestNotApplyData];
        [self requestAlreadyApplyData];
    });
}

- (void)closeBtnClick {
    [_calendarView removeFromSuperview];
}

- (void)KZNotApplyCell:(KZNotApplyCell *)cell applyBtnClick:(UIButton *)btn {
    
    if (!kBindBankCard || [kBindBankCard boolValue]==NO) {
        
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil
                                                                          message:@"请绑定银行卡"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            KZMyCardController *myCardCtl = [[KZMyCardController alloc] init];
            [self.navigationController pushViewController:myCardCtl animated:YES];
        }];
        [alertCtl addAction:cancleAction];
        [alertCtl addAction:sureAction];
        [self presentViewController:alertCtl animated:YES completion:nil];
        
    } else {
        //跳申请详情wap
        KZWebController *webVC = [[KZWebController alloc] init];
        webVC.webURL = [NSString stringWithFormat:kApplyDetailWapInterface,[kToken stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],cell.model.orderId];
        webVC.dynamicTitle = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - KZAlreadyApplyCellDelegate

//点击重新提交按钮
- (void)KZAlreadyApplyCell:(KZAlreadyApplyCell *)cell clickReCommitBtn:(UIButton *)reCommitBtn{
    //跳申请详情wap
    KZWebController *webVC = [[KZWebController alloc] init];
    webVC.webURL = [NSString stringWithFormat:kApplyDetailWapInterface,[kToken stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],cell.model.orderId];
    webVC.dynamicTitle = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark -- getters
- (NSString *)selectedDate {
    if (!_selectedDate) {
        _selectedDate = [self getYearMonthTime];
    }
    return _selectedDate;
}


@end
