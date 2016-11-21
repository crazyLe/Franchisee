//
//  WorkDetailsFrameModel.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkDetailsModel.h"


@interface WorkDetailsFrameModel : NSObject <UIWebViewDelegate>

@property(nonatomic,assign)CGRect titleRect;

//@property(nonatomic,assign)CGRect statueRect;

@property(nonatomic,assign)CGRect sendRect;

@property(nonatomic,assign)CGRect webRect;

//@property(nonatomic,assign)CGRect contentRect;
//
//@property(nonatomic,assign)CGRect imagefirRect;
//
//@property(nonatomic,assign)CGRect imagesecRect;

@property(nonatomic,assign)CGRect starTRect;

@property(nonatomic,assign)CGRect endTRect;

@property(nonatomic,assign)CGRect bottomRect;

@property(nonatomic,assign)CGRect bottonButtonRect;

@property(nonatomic,strong)WorkDetailsModel *model;

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,strong)UIWebView *web;

@property(nonatomic,assign)CGFloat webY;

@end
