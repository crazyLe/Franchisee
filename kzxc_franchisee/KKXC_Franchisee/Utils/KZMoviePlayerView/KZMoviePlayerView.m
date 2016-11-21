//
//  KZMoviePlayerView.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZMoviePlayerView.h"

@interface KZMoviePlayerView ()

@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *networkUrlStr;

@property (nonatomic,strong) NSArray *playbackTimes;

@end

@implementation KZMoviePlayerView

- (id)initWithFrame:(CGRect)frame fileName:(NSString *)fileName playbackTimes:(NSArray *)playbackTimes
{
    if (self = [super initWithFrame:frame]) {
        self.fileName = fileName;
        self.playbackTimes = playbackTimes;
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame networkUrlStr:(NSString *)networkUrlStr playbackTimes:(NSArray *)playbackTimes
{
    if (self = [super initWithFrame:frame]) {
        self.networkUrlStr = networkUrlStr;
        self.playbackTimes = playbackTimes;
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    //添加通知
    [self addNotification];
    
    //获取缩略图
    [self thumbnailImageRequest:isEmptyArr(_playbackTimes)?@[@13.0,@21.5]:_playbackTimes];
}

- (void)play{
     [self.moviePlayer play];
}

- (void)pause{
    [self.moviePlayer pause];
}

- (void)stop{
    [self.moviePlayer stop];
}

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 私有方法
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getFileUrl{
    NSString *urlStr=[[NSBundle mainBundle] pathForResource:_fileName ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl{
    NSString *urlStr=_networkUrlStr;
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        NSURL *url = nil;
        if (!isEmptyStr(_networkUrlStr)) {
            url = [self getNetworkUrl];
        }
        else if (!isEmptyStr(_fileName)) {
            url = [self getFileUrl];
        } else {
            NSLog(@"Alert! Place Confirm init KZMoviePlayerView Objcet with a file name or a network url string.");
            return nil;
        }
        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.view.frame=self.bounds;
        _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _moviePlayer.shouldAutoplay = NO;
        [self addSubview:_moviePlayer.view];
    }
    return _moviePlayer;
}

/**
 *  获取视频缩略图
 */
-(void)thumbnailImageRequest:(NSArray *)arr{
    //获取13.0s、21.5s的缩略图
    [self.moviePlayer requestThumbnailImagesAtTimes:arr timeOption:MPMovieTimeOptionNearestKeyFrame];
}

#pragma mark - 控制器通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.moviePlayer];
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(KZMoviePlayerView:mediaPlayerPlaybackStateChange:)]) {
        [_delegate KZMoviePlayerView:self mediaPlayerPlaybackStateChange:self.moviePlayer.playbackState];
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
    if (_delegate && [_delegate respondsToSelector:@selector(KZMoviePlayerView:mediaPlayerPlaybackFinished:)]) {
        [_delegate KZMoviePlayerView:self mediaPlayerPlaybackFinished:self.moviePlayer.playbackState];
    }
}

/**
 *  缩略图请求完成,此方法每次截图成功都会调用一次
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerThumbnailRequestFinished:(NSNotification *)notification{
    NSLog(@"视频截图完成.");
    
    UIImage *image=notification.userInfo[MPMoviePlayerThumbnailImageKey];

    if (_delegate && [_delegate respondsToSelector:@selector(KZMoviePlayerView:thumbnailRequestFinished:)]) {
        [_delegate KZMoviePlayerView:self thumbnailRequestFinished:image];
    }
}

/**
 从父视图移除自身
 */
- (void)dismiss{
    [self removeFromSuperview];
}

//拦截在播放器上的点击手势事件，防止触发tableView的didSelectRow方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

@end
