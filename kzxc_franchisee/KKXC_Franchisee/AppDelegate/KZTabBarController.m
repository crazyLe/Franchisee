//
//  KZTabBarController.m
//  KKXC_Franchisee
//
//  Created by sky on 2016/10/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZBindBankInfo.h"
#import "KZWorkController.h"
#import "KZTabBarController.h"
#import "KZNavitationController.h"
#import "KZMineController.h"
#import "KZIntentionListController.h"

@interface KZTabBarController ()

@end

@implementation KZTabBarController

/** 第一次调用类的时候会调用该方法 */
+ (void)initialize {
    // 设置UITabBarItem的主题
    [self setupTabBarItemTheme];
}

/** 设置UITabBarItem的主题 */
+ (void)setupTabBarItemTheme {
    // 通过设置 appearance对象，能够修改整个项目中所有UITabBarItem的样式
    UITabBarItem *appearance = [UITabBarItem appearance];

    [appearance setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#777777"],
                                         NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                                         } forState:UIControlStateNormal];

    [appearance setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#1D8FE1"],
                                         NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                                         } forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (kBindBankCard == nil) {
        [self requestBankInfo];
    }
    
    KZIntentionListController * intentionCtl = [[KZIntentionListController alloc] init];
    KZNavitationController *intentionNavCtl = [[KZNavitationController alloc] initWithRootViewController:intentionCtl];
    
    KZWorkController *workCtl = [[KZWorkController alloc] init];
    KZNavitationController *workNavCtl = [[KZNavitationController alloc] initWithRootViewController:workCtl];

    KZMineController *myCtl = [[KZMineController alloc] init];
    KZNavitationController *myNavCtl = [[KZNavitationController alloc] initWithRootViewController:myCtl];


    self.viewControllers = @[intentionNavCtl, workNavCtl, myNavCtl];
    
    self.selectedIndex = 1;

    NSArray *titles = @[ @"意向列表", @"工作", @"我的" ];
    NSArray *images = @[ @"icon_tabbar_intentList", @"icon_tabbar_work", @"icon_tabbar_mine"];

    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[[UIImage imageNamed:[images[idx] stringByAppendingString:@"_selected"]]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }];
}

//拉取绑定银行卡信息
- (void)requestBankInfo {
    NSString * url = kBankBindInfoUrl;
    [KZNetworkEngine postWithUrl:url paraDic:nil successBlock:^(id jsonObj) {
        NSInteger code = [jsonObj[@"code"] integerValue];
        NSDictionary *bankDic = jsonObj[@"data"];
        
        if (code == 1) {
            KZBindBankInfo *bankInfo = [KZBindBankInfo mj_objectWithKeyValues:bankDic];
            //存储银行卡是否绑定状态
            if (isEmptyStr(bankInfo.bankId)) {
                //未绑定
                [kUserDefault setObject:@(NO) forKey:@"kBindState"];
            } else {
                //已绑定
                [kUserDefault setObject:@(YES) forKey:@"kBindState"];
            }
        } else {
            
        }
    } failedBlock:^(NSError *error) {
        
    }];
}

@end
