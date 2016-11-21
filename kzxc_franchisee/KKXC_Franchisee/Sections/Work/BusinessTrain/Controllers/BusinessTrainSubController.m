//
//  BusinessTrainSubController.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZFullScreenImgCell.h"
#import "KZWebController.h"
#import "UIViewController+Refresh.h"
#import "KZBusinessTrainModel.h"
#import "KZVedioListCell.h"
#import "KZImageListCell.h"
#import "KZArticleListCell.h"
#import "BusinessTrainSubController.h"

@interface BusinessTrainSubController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *table;

@end

@implementation BusinessTrainSubController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVedioPlay) name:@"kStopVedioPlay" object:nil];
    
    self.view.backgroundColor = [UIColor clearColor];

    _table = [[UITableView alloc]initWithFrame:CGRectMake(0,65+44, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];

    _table.dataSource = self;
    _table.delegate = self;
    _table.tableFooterView = [UIView new];
    [self.view addSubview:_table];
    
    [self setScroll:_table networkAdd:kBusinessTrainInterface paraDic:@{@"article_type":@(_type)} pageFiledName:@"page" parseDicKeyArr:@[@"data"] parseModelName:@"KZBusinessTrainModel"];
    [self refreshScroll];
    
    _table.backgroundColor = [UIColor clearColor];
    
    NSArray *registerArr = nil;
    switch (_type) {
        case BusinessTrainSubControllerTypeAll:
        {
            registerArr = @[@"KZArticleListCell",@"KZImageListCell",@"KZVedioListCell"];
        }
            break;
        case BusinessTrainSubControllerTypeArticle:
        {
            registerArr = @[@"KZArticleListCell",@"KZFullScreenImgCell"];
        }
            break;
        case BusinessTrainSubControllerTypeImage:
        {
            registerArr = @[@"KZImageListCell"];
        }
            break;
        case BusinessTrainSubControllerTypeVedio:
        {
            registerArr = @[@"KZVedioListCell"];
        }
            break;
            
        default:
            break;
    }
    [self registerNibWithClassNameArr:registerArr cellIdentifier:nil table:_table];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopVedioPlay];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    switch (_type) {
        case BusinessTrainSubControllerTypeAll:
        {
            switch (indexPath.row) {
                case 0:
                {
                    KZArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZArticleListCell"];
                    
                    return cell;
                }
                    break;
                case 1:
                {
                    KZImageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZImageListCell"];
                    
                    return cell;
                }
                    break;
                case 2:
                {
                    KZVedioListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZVedioListCell"];
                    
                    return cell;
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case BusinessTrainSubControllerTypeArticle:
        {

        }
            break;
        case BusinessTrainSubControllerTypeImage:
        {

        }
            break;
        case BusinessTrainSubControllerTypeVedio:
        {

        }
            break;
            
        default:
            break;
    }
     */
    KZBusinessTrainModel *model = self.contentArr[indexPath.row];
    switch ([model.articleType intValue]) {
        case BusinessTrainSubControllerTypeArticle:
        {
            //文章
            if (_type == BusinessTrainSubControllerTypeArticle && indexPath.row==0) {
                KZFullScreenImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZFullScreenImgCell"];
                cell.model = model;
                return cell;
            } else {
                KZArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZArticleListCell"];
                cell.titleLbl.text = model.title;
                cell.contentLbl.text = model.remark;
                [cell.rightImgView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:kPlaceHolder_1_1]];
                return cell;
            }
        }
            break;
        case BusinessTrainSubControllerTypeVedio:
        {
            //视频
            KZVedioListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZVedioListCell"];
            cell.titleLbl.text = model.title;
            [cell setVedioUrlStr:model.video];
            return cell;
        }
            break;
        case BusinessTrainSubControllerTypeImage:
        {
            //图片
            KZImageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KZImageListCell"];
            cell.titleLbl.text = model.title;
            [cell setImgWithImageUrlStr:model.image];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KZBusinessTrainModel *model = self.contentArr[indexPath.row];
    switch ([model.articleType intValue]) {
        case BusinessTrainSubControllerTypeArticle:
        {
            return 125;
        }
            break;
        case BusinessTrainSubControllerTypeImage:
        {
            return 200;
        }
            break;
        case BusinessTrainSubControllerTypeVedio:
        {
            return 300;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KZBusinessTrainModel *businessTrainModel = self.contentArr[indexPath.row];
    KZWebController *webVC = [[KZWebController alloc] init];
    webVC.webURL = [kWorkArticleInterface stringByAppendingPathComponent:businessTrainModel.idNum];
    webVC.dynamicTitle = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[KZVedioListCell class]]) {
        //播放器停止播放
        KZVedioListCell *vedioCell = (KZVedioListCell *)cell;
        [vedioCell stopVedio];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)stopVedioPlay{
    //停止播放器播放
    for (UITableViewCell *cell in _table.visibleCells) {
        if ([cell isKindOfClass:[KZVedioListCell class]]) {
            //播放器停止播放
            KZVedioListCell *vedioCell = (KZVedioListCell *)cell;
            [vedioCell stopVedio];
        }
    }
}



@end
