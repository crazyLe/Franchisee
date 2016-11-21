//
//  KZWorkBannerCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZBannerModel.h"
#import "KZWorkBannerCell.h"

@implementation KZWorkBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _cycleScrollView.pageControlAliment =SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    //    cycleScrollView.titlesGroup = titles;
    //    cycleScrollView.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.autoScrollTimeInterval = 3.0f;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"banner"];
    _cycleScrollView.imageURLStringsGroup = @[@"banner"];
}

- (void)setBannerModelArr:(NSArray *)bannerModelArr{
    if (_bannerModelArr != bannerModelArr) {
        _bannerModelArr = bannerModelArr;
        NSMutableArray *imgUrlArr = [NSMutableArray array];
        for (KZBannerModel *model in _bannerModelArr) {
            [imgUrlArr addObject:model.image];
        }
        _cycleScrollView.imageURLStringsGroup = imgUrlArr;
    }
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

@end
