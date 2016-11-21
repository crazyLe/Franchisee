//
//  KZWorkScheduleDetailsController.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWorkScheduleDetailsController.h"
#import "WorkDetailsCell.h"
#import "WorkDetailsModel.h"
#import "WorkDetailsFrameModel.h"
#import "KZWorkLogController.h"

@interface KZWorkScheduleDetailsController ()<UITableViewDelegate,UITableViewDataSource,WorkDetailsCellDelegate,UIWebViewDelegate>

{
    NSMutableArray *workframeModels;
    CGFloat webHeight;
}

@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)UIWebView *web;

@property(nonatomic,strong)WorkDetailsModel *model;
@property(nonatomic,strong)WorkDetailsFrameModel *frameModel;

@end

@implementation KZWorkScheduleDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    _frameModel = [[WorkDetailsFrameModel alloc]init];
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _web = [[UIWebView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth -10, 1)];
    _web.delegate = self;
    _web.scrollView.bounces = NO;
    _web.scrollView.showsHorizontalScrollIndicator = NO;
    _web.scrollView.scrollEnabled = NO;
    [_web sizeToFit];
    [self.view addSubview:_web];

    [self loadNetWorkData];

}

- (void) setupNav {
    
    self.title = @"工作详情";
    
    if (1 == [_type intValue]) {
        [self setRightText:@"提前完成" textColor:[UIColor colorWithHexString:@"#1d8fe1"] ImgPath:nil action:@selector(accomplished)];
    }
}

- (void)accomplished {

    KZWorkLogController *worklog = [[KZWorkLogController alloc]init];
    worklog.taskId = _taskId;
    worklog.state = 1;
    [self.navigationController pushViewController:worklog animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    CGRect frame = webView.frame;
    frame.size.width = kScreenWidth;
    frame.size.height = 1;
    webView.frame = frame;
    frame.size.height = webView.scrollView.contentSize.height;
    webHeight = webView.scrollView.contentSize.height + 20;
    _model.webY = webHeight;
    [_table reloadData];
}

- (void)loadNetWorkData {
    
    [self.hudManager showNormalStateSVHudWithTitle:@"加载中..." hideAfterDelay:10.0];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"task_id"] = _taskId;
    [KZNetworkEngine postWithUrl:workScheduleDetailsUrl paraDic:param successBlock:^(id jsonObj) {
        [self.hudManager dismissSVHud];
        _model = [WorkDetailsModel mj_objectWithKeyValues:jsonObj[@"data"]];
        [_web loadHTMLString:_model.taskContent baseURL:nil];
    } failedBlock:^(NSError *error) {
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sec = (_model == nil)?0:1;
    return sec;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *identify = @"WorkDetailsCell";
    WorkDetailsCell  *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[WorkDetailsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    _frameModel.model = _model;
    cell.frameModel = _frameModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = _frameModel.cellHeight;
    return height;
}

- (void)gotoAddKZWorkLogController:(WorkDetailsFrameModel *)frameModel {
    
    KZWorkLogController *worklog = [[KZWorkLogController alloc]init];
    worklog.taskId = _taskId;
    worklog.state = 0;
    [self.navigationController pushViewController:worklog animated:YES];
}

@end
