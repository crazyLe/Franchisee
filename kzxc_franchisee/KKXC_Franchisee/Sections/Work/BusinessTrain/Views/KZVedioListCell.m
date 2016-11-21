//
//  KZVedioListCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZVedioListCell.h"

@implementation KZVedioListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

/**
 设置视频播放的url字符串
 */
- (void)setVedioUrlStr:(NSString *)urlStr{
    if (_playView) {
        [_playView dismiss] , _playView = nil;
    }
    _playView = [[KZMoviePlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-15*2, 210) networkUrlStr:urlStr playbackTimes:nil];
    [_playBgView addSubview:_playView];
    [_playBgView sendSubviewToBack:_playView];
    _playView.delegate = self;
}

/**
 停止播放器播放
 */
- (void)stopVedio{
    [_playView stop];
    _playBtn.hidden = NO;
}

/**
 暂停播放器播放
 */
- (void)pauseVedio{
    [_playView pause];
}

- (IBAction)clickPlayBtn:(id)sender {
    //播放
    [_playView play];
    _playBtn.hidden = YES;
}

#pragma mark - KZMoviePlayerViewDelegate

//完成获取缩略图回调
- (void)KZMoviePlayerView:(KZMoviePlayerView *)view thumbnailRequestFinished:(UIImage *)image{
    
}

//播放器状态改变回调
- (void)KZMoviePlayerView:(KZMoviePlayerView *)view mediaPlayerPlaybackStateChange:(MPMoviePlaybackState)state{
    
}

//播放器播放完成回调
- (void)KZMoviePlayerView:(KZMoviePlayerView *)view mediaPlayerPlaybackFinished:(MPMoviePlaybackState)state{
    _playBtn.hidden = NO;
}

@end
