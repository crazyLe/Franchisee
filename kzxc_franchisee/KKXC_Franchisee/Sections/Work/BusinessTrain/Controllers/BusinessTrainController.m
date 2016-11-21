//
//  BusinessTrainController.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "BusinessTrainSubController.h"
#import "SGTopTitleView.h"
#import "BusinessTrainController.h"

@interface BusinessTrainController () <SGTopTitleViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) SGTopTitleView *topTitleView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *titles;

//数据源
@property (nonatomic,strong) NSMutableArray *sortDataSource;
@property (nonatomic,strong) NSMutableArray *mainDataSource;

@end

@implementation BusinessTrainController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"业务培训";
    
    // 1.添加所有子控制器
    [self setupChildViewController];
    
    
    self.titles = @[@"全部", @"文章", @"图片",@"视频"];
    
    self.topTitleView = [SGTopTitleView topTitleViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    _topTitleView.staticTitleArr = [NSArray arrayWithArray:_titles];
//    _topTitleView.isHiddenIndicator = YES;
    _topTitleView.delegate_SG = self;
    [self.view addSubview:_topTitleView];
    self.topTitleView.backgroundColor = [UIColor whiteColor];
    
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _titles.count, 0);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
//    BusinessTrainSubController *oneVC = [[BusinessTrainSubController alloc] init];
//    [self.mainScrollView addSubview:oneVC.view];
//    [self addChildViewController:oneVC];
    
    for (int i = (int)_titles.count-1; i >=0 ; i--) {
        [self showVc:i];
    }
    
    [self.view insertSubview:_mainScrollView belowSubview:_topTitleView];
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index{
    
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
    
    [self postNotificationToStopVedio];
}

// 添加所有子控制器
- (void)setupChildViewController {
    for (int i = 0; i < 4; i++) {
        BusinessTrainSubController *oneVC = [[BusinessTrainSubController alloc] init];
        oneVC.type = i==2?3:i==3?2:i;
        [self addChildViewController:oneVC];
    }
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
    
    // 2.把对应的标题选中
    UILabel *selLabel = self.topTitleView.allTitleLabel[index];
    
    // 3.滚动时，改变标题选中
    [self.topTitleView staticTitleLabelSelecteded:selLabel];
    
    [self postNotificationToStopVedio];
}

- (void)postNotificationToStopVedio{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kStopVedioPlay" object:nil];
}

@end
