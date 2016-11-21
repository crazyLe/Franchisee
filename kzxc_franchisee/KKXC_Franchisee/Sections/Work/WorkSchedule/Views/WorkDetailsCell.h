//
//  WorkDetailsCell.h
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkDetailsFrameModel.h"

@protocol WorkDetailsCellDelegate <NSObject>

@optional
- (void)gotoAddKZWorkLogController:(WorkDetailsFrameModel *)frameModel;

@end


@interface WorkDetailsCell : UITableViewCell

//模块标题
@property(nonatomic,strong)UILabel *contentTitle;
//状态
@property(nonatomic,strong)UIImageView *statueImage;
//发布时间
@property(nonatomic,strong)UILabel *contenTime;

@property(nonatomic,strong)UIWebView *contentWeb;
//详细内容
//@property(nonatomic,strong)UILabel *detailsContent;
//第一张图片按钮
//@property(nonatomic,strong)UIImageView *photoFirst;
//第二张图片按钮
//@property(nonatomic,strong)UIImageView *photoSecond;
//开始时间
@property(nonatomic,strong)UILabel *starTime;
//结束时间
@property(nonatomic,strong)UILabel *endTime;
//底部view
@property(nonatomic,strong)UILabel *resultlabel;
@property(nonatomic,strong)UILabel *leftlabel;
@property(nonatomic,strong)UIButton *dayButton;
@property(nonatomic,strong)UILabel *rightDay;
@property(nonatomic,strong)UIImageView *bottomView;
//添加按钮
@property(nonatomic,strong)UIButton *addButton;

@property(nonatomic,weak)id <WorkDetailsCellDelegate> delegate;

@property(nonatomic,strong)WorkDetailsFrameModel *frameModel;

@end
