//
//  UIViewController+Refresh.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Refresh)

/**
 设置网络下拉上拉时网络请求的地址和请求参数，页码参数名、以及指定如何解析返回数据
 1.scrollView   : 需要下拉刷新 下拉加载的tableView 或者 collectionView
 2.add          : 请求的地址
 3.paraDic      : 请求字典
 4.pageFileNmae : 页码参数名
 5.dicKeyArr    : 解析返回数据的Key数组
 6.modelName   :  解析的Model类 如果传入nil 则解析出来的contentArr是字典数组(KeyValues形式)
 */
- (void)setScroll:(UIScrollView *)scrollView networkAdd:(NSString *)add paraDic:(NSDictionary *)paraDic pageFiledName:(NSString *)pageFiledName parseDicKeyArr:(NSArray *)dicKeyArr parseModelName:(NSString *)modelName;

/**
 获取数据源
 如果在 setNetwrokAdd 时指定了modelClass 则 此方法返回的数组由指定的model类对象组成
 如果在 setNetwrokAdd 时modelClass参数传入nil 则 此方法返回的数组是由字典组成
 */
- (NSMutableArray *)contentArr;

/**
 获取表
 */
- (UIScrollView *)bg_ScrollView;

/**
 触发下拉刷新
 */
- (void)refreshScroll;

@end

@interface UIScrollView (ReloadExtension)

- (void)reloadData;

@end
