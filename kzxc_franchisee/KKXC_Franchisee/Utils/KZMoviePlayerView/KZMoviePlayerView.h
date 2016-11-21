//
//  KZMoviePlayerView.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

@class KZMoviePlayerView;

@protocol KZMoviePlayerViewDelegate <NSObject>

@optional
//完成获取缩略图回调
- (void)KZMoviePlayerView:(KZMoviePlayerView *)view thumbnailRequestFinished:(UIImage *)image;
//播放器状态改变回调
- (void)KZMoviePlayerView:(KZMoviePlayerView *)view mediaPlayerPlaybackStateChange:(MPMoviePlaybackState)state;
//播放器播放完成回调
- (void)KZMoviePlayerView:(KZMoviePlayerView *)view mediaPlayerPlaybackFinished:(MPMoviePlaybackState)state;

@end

@interface KZMoviePlayerView : UIView

//初始化方法
- (id)initWithFrame:(CGRect)frame fileName:(NSString *)fileName playbackTimes:(NSArray *)playbackTimes;
- (id)initWithFrame:(CGRect)frame networkUrlStr:(NSString *)networkUrlStr playbackTimes:(NSArray *)playbackTimes;

//开始/恢复播放
- (void)play;

//暂停播放
- (void)pause;

//停止播放
- (void)stop;

/**
 从父视图移除自身
 */
- (void)dismiss;

//视频播放控制器
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;

//代理
@property (nonatomic,assign) id <KZMoviePlayerViewDelegate> delegate;

@end
