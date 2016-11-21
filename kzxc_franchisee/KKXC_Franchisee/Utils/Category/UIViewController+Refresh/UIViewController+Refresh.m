//
//  UIViewController+Refresh.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

typedef void(^requestBlock)(NSInteger page);

#import <objc/runtime.h>
#import <MJRefresh.h>
#import "UIViewController+Refresh.h"

static const char scrollPageCountKey;
static const char scrollViewKey;
static const char scrollContentArrKey;

@implementation UIViewController (Refresh)

- (void)setScrollRefreshHandle:(requestBlock)actionHandler
{
    NSUInteger _pageCount = 1;
    [self setPageCount:_pageCount];
    
    __weak UIScrollView *_bg_ScrollView = self.bg_ScrollView;
    
    NSUInteger *pageCountWeak = &_pageCount;
    _bg_ScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        actionHandler(*pageCountWeak=1);
    }];
    
    _bg_ScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        actionHandler(++*pageCountWeak);
    }];
}

- (void)setScroll:(UIScrollView *)scrollView networkAdd:(NSString *)add paraDic:(NSDictionary *)paraDic pageFiledName:(NSString *)pageFiledName parseDicKeyArr:(NSArray *)dicKeyArr parseModelName:(NSString *)modelName
{
    WeakObj(self)
    
    if (!scrollView) {
        NSLog(@"plase set tableView or collectionView");
        return;
    } else if(!add){
        NSLog(@"plase set network request address");
        return;
    }
    
    [self setBg_ScrollView:scrollView];
    
    [self setScrollRefreshHandle:^(NSInteger page) {
        NSMutableDictionary *paraMutDic = [paraDic mutableCopy];
        if (pageFiledName) {
            [paraMutDic setObject:[NSString stringWithFormat:@"%ld",page] forKey:pageFiledName];
        }
        [KZNetworkEngine postWithUrl:add paraDic:paraMutDic successBlock:^(id jsonObj) {
            if (page==1) {
                //Drop down
                selfWeak.contentArr = [[selfWeak parseJsonDataWithJsonObj:jsonObj dicKeyArr:dicKeyArr parseModelName:modelName] mutableCopy];
                [selfWeak.bg_ScrollView reloadData];
                [selfWeak.bg_ScrollView.mj_header endRefreshing];
                [selfWeak contentArrDidRefresh:selfWeak.contentArr];
            }
            else
            {
                if (!isNull(jsonObj[@"info"])) {
                    NSArray *appendArr = [selfWeak parseJsonDataWithJsonObj:jsonObj dicKeyArr:dicKeyArr parseModelName:modelName];
                    if (appendArr.count) {
                        //还有数据 （追加）
                        [selfWeak.contentArr addObjectsFromArray:appendArr];
                        [selfWeak.bg_ScrollView reloadData];
                        [selfWeak contentArrDidLoadMoreData:appendArr];
                    }
                    else
                    {
                        //No more data
                        [selfWeak noMoreData];
                    }
                }
                else
                {
                    
                }
                [selfWeak.bg_ScrollView.mj_footer endRefreshing];
            }
        } failedBlock:^(NSError *error) {
            [selfWeak.bg_ScrollView.mj_header endRefreshing];
            [selfWeak.bg_ScrollView.mj_footer endRefreshing];
        }];
    }];
}

//已经重新加载了数据
- (void)contentArrDidRefresh:(NSArray *)newArr
{
    
}

//已经追加了数据
- (void)contentArrDidLoadMoreData:(NSArray *)appendArr
{
    
}

//没有更多数据了
- (void)noMoreData
{
    
}

//静默刷新
- (void)silenceRefresh
{
    
}

//触发下拉刷新
- (void)refreshScroll{
    [self.bg_ScrollView.mj_header beginRefreshing];
}

//解析json数据
- (NSArray *)parseJsonDataWithJsonObj:(id)jsonObj dicKeyArr:(NSArray *)dicKeyArr parseModelName:(NSString *)modelName
{
    id arr = nil;
    int i = 0;
    for (NSString *dicKey in dicKeyArr)
    {
        if (i==0)
        {
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                arr = jsonObj[dicKey];
            }
            else if([jsonObj isKindOfClass:[NSArray class]])
            {
                if (((NSArray *)jsonObj).count) {
                    arr = jsonObj[0];
                }
            }
        }
        else
        {
            if ([arr isKindOfClass:[NSDictionary class]]) {
                arr = arr[dicKey];
            }
            else if([arr isKindOfClass:[NSArray class]])
            {
                if (((NSArray *)arr).count) {
                    arr = arr[0];
                }
            }
        }
        i++;
    }
    
    if ([arr isKindOfClass:[NSArray class]]) {
        if (modelName) {
            return [NSClassFromString(modelName) mj_objectArrayWithKeyValuesArray:arr];
        } else {
            return arr;
        }
    }
    else if(!isNull(arr))
    {
        if (modelName) {
            return [NSClassFromString(modelName) mj_objectArrayWithKeyValuesArray:@[arr]];
        } else {
            return @[arr];
        }
    }
    else
    {
        return @[];
    }
}

#pragma mark - GET && SET

- (NSUInteger)getPageCount{
    return [objc_getAssociatedObject(self, &scrollPageCountKey) unsignedIntegerValue];
}
- (void)setPageCount:(NSUInteger)pageCount{
    objc_setAssociatedObject(self, &scrollPageCountKey, @(pageCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)contentArr{
    return objc_getAssociatedObject(self, &scrollContentArrKey);
}
- (void)setContentArr:(NSMutableArray *)contentArr{
    objc_setAssociatedObject(self, &scrollContentArrKey, contentArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIScrollView *)bg_ScrollView{
    return objc_getAssociatedObject(self, &scrollViewKey);;
}
- (void)setBg_ScrollView:(UIScrollView *)bg_ScrollView{
    objc_setAssociatedObject(self, &scrollViewKey, bg_ScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIScrollView (ReloadExtension)

- (void)reloadData{
    if ([self isKindOfClass:[UITableView class]]) {
        [(UITableView *)self reloadData];
    } else if([self isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)self reloadData];
    }  else{
        NSLog(@"plase invoke 'setScroll' to set the tableView or collectionView");
    }
}

@end
