//
//  KZWorkBannerCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <SDCycleScrollView.h>
#import <UIKit/UIKit.h>

@interface KZWorkBannerCell : UITableViewCell <SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong) NSArray *bannerModelArr;

@end
