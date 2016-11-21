//
//  KZVedioListCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMoviePlayerView.h"
#import <UIKit/UIKit.h>

@interface KZVedioListCell : UITableViewCell <KZMoviePlayerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *playBgView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;


@property (nonatomic,strong)KZMoviePlayerView *playView;

/**
 设置视频播放的url字符串
 */
- (void)setVedioUrlStr:(NSString *)urlStr;

/**
 停止播放器播放
 */
- (void)stopVedio;
/**
 暂停播放器播放
 */
- (void)pauseVedio;

@end
