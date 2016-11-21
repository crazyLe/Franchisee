//
//  KZAboutController.m
//  KKXC_Franchisee
//
//  Created by gaobin on 16/8/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZAboutController.h"
#import "ConpanyIntroduceCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "ContactOurCell.h"

@interface KZAboutController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * currentBtn;
@property (nonatomic, assign) BOOL isIntroduceCell;

@end

@implementation KZAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _isIntroduceCell = YES;
    
    self.title = @"关于康庄";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
    
}
- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self createHeaderView];
    [_tableView registerNib:[UINib nibWithNibName:@"ConpanyIntroduceCell" bundle:nil] forCellReuseIdentifier:@"ConpanyIntroduceCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ContactOurCell" bundle:nil] forCellReuseIdentifier:@"ContactOurCell"];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isIntroduceCell) {
        static NSString * identifier = @"ConpanyIntroduceCell";
        
        ConpanyIntroduceCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        
        static NSString * identifier = @"ContactOurCell";
        
        ContactOurCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
  
}
- (UIView *)createHeaderView {
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 290)];
    
    UIImageView * headerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about-img"]];
    [headerView addSubview:headerImgView];
    [headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.bottom.offset(-110);
    }];
    
    
    UIButton * introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [introduceBtn setTitle:@"公司\n简介" forState:UIControlStateNormal];
    [introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    introduceBtn.titleLabel.numberOfLines = 2;
    [introduceBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-bluebg"] forState:UIControlStateSelected];
    [introduceBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-graybg"] forState:UIControlStateNormal];
    introduceBtn.selected = YES;
    introduceBtn.userInteractionEnabled = NO;
    _currentBtn = introduceBtn;
    introduceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [introduceBtn addTarget:self action:@selector(introduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:introduceBtn];
    [introduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(70);
        make.top.equalTo(headerImgView.mas_bottom).offset(16);
        make.height.width.offset(80);
    }];
    
    UIButton * contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactBtn setTitle:@"联系\n我们" forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    contactBtn.titleLabel.numberOfLines = 2;
    [contactBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-bluebg"] forState:UIControlStateSelected];
    [contactBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-graybg"] forState:UIControlStateNormal];
    contactBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [contactBtn addTarget:self action:@selector(contactBtnClick: ) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:contactBtn];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-70);
         make.top.equalTo(headerImgView.mas_bottom).offset(16);
        make.height.width.offset(80);
    }];

  
    
    
    return headerView;
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isIntroduceCell) {
        
        return [tableView fd_heightForCellWithIdentifier:@"ConpanyIntroduceCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            
        }];
        
    } else {
        return 200;
    }

}
- (void)introduceBtnClick:(UIButton *)btn {
    
  
    btn.selected = YES;
    
    _currentBtn.selected = NO;
    _currentBtn.userInteractionEnabled = YES;
    btn.userInteractionEnabled = NO;
    
    _currentBtn = btn;
    
    _isIntroduceCell = YES;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

}
- (void)contactBtnClick:(UIButton *)btn {
    
    btn.selected = YES;
    
    _currentBtn.selected = NO;
    _currentBtn.userInteractionEnabled = YES;
    btn.userInteractionEnabled = NO;
    
    _currentBtn = btn;
    
    _isIntroduceCell = NO;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

}

@end
