//
//  WorkDetailsFrameModel.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#define letfpadding 15
#define padding 10
#define toppadding 25

#import "WorkDetailsFrameModel.h"
#import "NSString+Size.h"

@implementation WorkDetailsFrameModel


-(void)setWebY:(CGFloat)webY
{
    _webY = webY;
}

- (void)setModel:(WorkDetailsModel *)model
{
    _model = model;
    
    NSString *ss = [NSString stringWithFormat:@"%@  %@",_model.taskName,@"进行中"];
    CGSize titleSize = [ss boundingRectWithSize:CGSizeMake(kScreenWidth - 30,CGFLOAT_MAX)   options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:21.0]} context:nil].size;
    
    
    _titleRect = CGRectMake(letfpadding, 25, titleSize.width, titleSize.height);
    
    //    _statueRect = CGRectMake(letfpadding + titleSize.width + padding, 5 + toppadding, 55, 15);
    
    _sendRect = CGRectMake(letfpadding, CGRectGetMaxY(_titleRect)+padding, kScreenWidth - 30, 15);
    
    //    CGSize contentSize = [NSString string: _model.taskContent sizeWithFont:Font16 maxSize:CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX)];
    
    //    _contentRect = CGRectMake(letfpadding, CGRectGetMaxY(_sendRect)+2*padding, kScreenWidth - 30, contentSize.height);
    
    //    _imagefirRect = CGRectMake(letfpadding, CGRectGetMaxY(_contentRect)+2*padding, 120, 120);
    //
    //    _imagesecRect = CGRectMake(letfpadding + padding + 120, CGRectGetMaxY(_contentRect)+2*padding, 120, 120);
    
    _webRect = CGRectMake(5, CGRectGetMaxY(_sendRect) , kScreenWidth - 10 , _model.webY);
    
    _starTRect = CGRectMake(letfpadding, CGRectGetMaxY(_webRect)+padding, 140, 20);
    
    _endTRect = CGRectMake(kScreenWidth - 140 - 15, CGRectGetMaxY(_webRect)+padding, 140, 20);
    
    _bottomRect = CGRectMake(letfpadding, CGRectGetMaxY(_starTRect)+2*padding, kScreenWidth - 30, 40);
    
    _bottonButtonRect = CGRectMake(letfpadding, CGRectGetMaxY(_bottomRect)+5*padding, kScreenWidth - 30, 45);
    
    _cellHeight = CGRectGetMaxY(_bottonButtonRect) + 20;
}


@end
