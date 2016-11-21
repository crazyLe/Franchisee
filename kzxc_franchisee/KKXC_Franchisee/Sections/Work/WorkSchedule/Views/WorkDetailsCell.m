//
//  WorkDetailsCell.m
//  KKXC_Franchisee
//
//  Created by Qing on 2016/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "WorkDetailsCell.h"

@implementation WorkDetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        //        内容标题
        _contentTitle = [[UILabel alloc]init];
        _contentTitle.lineBreakMode = NSLineBreakByWordWrapping;
        _contentTitle.numberOfLines = 0;
        _contentTitle.font = [UIFont boldSystemFontOfSize:21.0];
        _contentTitle.textColor = [UIColor colorWithHexString:@"#1b1b1b"];
        _contentTitle.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_contentTitle];
        //        状态图片
        _statueImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:_statueImage];
        
        //        发布时间
        _contenTime = [[UILabel alloc]init];
        [self addSubview:_contenTime];
        _contenTime.font = Font11;
        _contenTime.textColor = [UIColor colorWithHexString:@"#999999"];
        _contenTime.textAlignment = NSTextAlignmentLeft;
        
        _contentWeb = [[UIWebView alloc]init];
        _contentWeb.backgroundColor = [UIColor yellowColor];
        _contentWeb.scrollView.bounces = NO;
        _contentWeb.scrollView.showsHorizontalScrollIndicator = NO;
        _contentWeb.scrollView.scrollEnabled = NO;
        [_contentWeb sizeToFit];
        [self addSubview:_contentWeb];
        
        //        详细内容
//        _detailsContent = [[UILabel alloc] init];
//        _detailsContent.numberOfLines = 0;
//        [self addSubview:_detailsContent];
//        _detailsContent.font = Font16;
//        _detailsContent.textColor = ColorThree;
//        
//        //        图片
//        _photoFirst = [[UIImageView alloc]init];
//        [self addSubview:_photoFirst];
//        
//        _photoSecond = [[UIImageView alloc]init];
//        [self addSubview:_photoSecond];
        
        //        开始时间 、结束时间
        _starTime = [[UILabel alloc]init];
        [self addSubview:_starTime];
        _starTime.font = Font14;
        _starTime.textColor = [UIColor colorWithHexString:@"#999999"];
        _starTime.textAlignment = NSTextAlignmentLeft;
        
        _endTime = [[UILabel alloc]init];
        [self addSubview:_endTime];
        _endTime.font = Font14;
        _endTime.textColor = [UIColor colorWithHexString:@"#999999"];
        _endTime.textAlignment = NSTextAlignmentRight;
        
        //        底部视图
        _bottomView = [[UIImageView alloc]init];
        [self addSubview:_bottomView];
        
        _resultlabel = [[UILabel alloc]init];
        _resultlabel.font = Font12;
        _resultlabel.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:_resultlabel];
        
        _leftlabel = [[UILabel alloc]init];
        _leftlabel.font = Font12;
        [_bottomView addSubview:_leftlabel];
        
        _dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dayButton.titleLabel.font = Font18;
        [_bottomView addSubview:_dayButton];
        
        _rightDay = [[UILabel alloc]init];
        _rightDay.font = Font12;
        
        _rightDay.text = @"天";
        [_bottomView addSubview:_rightDay];
        
        //        底部按钮
        _addButton = [[UIButton alloc]init];
        [self addSubview:_addButton];
        
        _addButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton setTitle:@"添加日志" forState:UIControlStateNormal];

        [_addButton addTarget:self action:@selector(addWorkLog) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void)addWorkLog
{
    if ([self.delegate respondsToSelector:@selector(gotoAddKZWorkLogController:)]) {
        [_delegate gotoAddKZWorkLogController:_frameModel];
    }
}

- (void)setFrameModel:(WorkDetailsFrameModel *)frameModel
{
    _frameModel = frameModel;
    
    [self setUIFrame];

    [self setData];
}

- (void)setUIFrame
{
    _contentTitle.frame = _frameModel.titleRect;
    
//    _statueImage.frame = _frameModel.statueRect;
    
    _contenTime.frame = _frameModel.sendRect;
    
//    _detailsContent.frame = _frameModel.contentRect;
//    
//    _photoFirst.frame = _frameModel.imagefirRect;
//    
//    _photoSecond.frame = _frameModel.imagesecRect;
    
    _contentWeb.frame = _frameModel.webRect;
    
    _starTime.frame = _frameModel.starTRect;
    
    _endTime.frame = _frameModel.endTRect;
    
    _bottomView.frame = _frameModel.bottomRect;
    
    [_resultlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(_frameModel.bottomRect), 45));
        make.left.mas_equalTo(@0);
    }];
    
    [_leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(90, 45));
        make.left.mas_equalTo((kScreenWidth - 135 - 30)/2);
    }];
    
    [_dayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.equalTo(_leftlabel.mas_right).offset(0);
    }];
    
    [_rightDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(15, 45));
        make.left.equalTo(_dayButton.mas_right).offset(5);
    }];
    
    _addButton.frame = _frameModel.bottonButtonRect;
}

- (void)setData
{
    WorkDetailsModel *model = _frameModel.model;
    
    NSString *addtime = [self getStamptimeWithString:model.addTime andSec:0];
    _contenTime.text = [NSString stringWithFormat:@"康庄学车%@发布",addtime];
    
    [_contentWeb loadHTMLString:_frameModel.model.taskContent baseURL:nil];
    
    NSString *begintime = [self getStamptimeWithString:model.bTime andSec:0];
    _starTime.text = [NSString stringWithFormat:@"开始时间:%@",begintime];
    
    NSString *endtime = [self getStamptimeWithString:model.eTime andSec:0];
    _endTime.text =[NSString stringWithFormat:@"结束时间:%@",endtime];

    _bottomView.image = [UIImage imageNamed:@"work_bottom_one"];
    
    NSMutableAttributedString *taskNameAttrStr = [[NSMutableAttributedString alloc]initWithString:_frameModel.model.taskName];
    
    [taskNameAttrStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:21.0]} range:NSMakeRange(0, _frameModel.model.taskName.length)];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    
    if([_frameModel.model.state isEqualToString:@"1"]) {
        // 表情图片
        attch.image = [UIImage imageNamed:@"doing_right_icon"];
        _bottomView.image = [UIImage imageNamed:@"work_bottom_one"];
        [_addButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1d8fe1"]] forState:UIControlStateNormal];
        _leftlabel.textColor = [UIColor colorWithHexString:@"#ff801a"];
        _rightDay.textColor = [UIColor colorWithHexString:@"#ff801a"];
        _leftlabel.text = @"距工作结束还有";
        int day =  (int)ceilf(([model.eTime intValue]- [[self getcurrentTime] intValue])/86400.0f);
        NSString *dayStr = [NSString stringWithFormat:@"%d",day];
        [_dayButton setTitle:dayStr forState:UIControlStateNormal];
        [_dayButton setBackgroundImage:[UIImage imageNamed:@"day_doing_statue"] forState:UIControlStateNormal];
        [self resultHiden];
    } else if ([_frameModel.model.state isEqualToString:@"2"]) {
        // 表情图片
        attch.image = [UIImage imageNamed:@"star_right_icon"];
        _bottomView.image = [UIImage imageNamed:@"work_bottom_two"];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"bottom_selected"] forState:UIControlStateNormal];
        _addButton.enabled = NO;
        _leftlabel.textColor = [UIColor colorWithHexString:@"#17af69"];
        _rightDay.textColor = [UIColor colorWithHexString:@"#17af69"];
        _leftlabel.text = @"距工作开始还有";
        int day =  (int)ceilf(([model.bTime intValue]- [[self getcurrentTime] intValue])/86400.0f);
        NSString *dayStr = [NSString stringWithFormat:@"%d",day];
        [_dayButton setTitle:dayStr forState:UIControlStateNormal];
        [_dayButton setBackgroundImage:[UIImage imageNamed:@"day_star_statue"] forState:UIControlStateNormal];
        [self resultHiden];
    } else if ([_frameModel.model.state isEqualToString:@"3"]) {
        // 表情图片
        attch.image = [UIImage imageNamed:@"end_right_icon"];
        _bottomView.image = [UIImage imageNamed:@"work_bottom_three"];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"work_wait"] forState:UIControlStateNormal];
        _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_addButton setTitleColor:[UIColor colorWithHexString:@"#1d8fe1"] forState:UIControlStateNormal];
        [_addButton setTitle:model.resultStr forState:UIControlStateNormal];
        _addButton.enabled = NO;
        _leftlabel.textColor = [UIColor colorWithHexString:@"#17af69"];
        _leftlabel.text = _frameModel.model.resultStr;
        [_leftlabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@200);
            make.left.mas_equalTo(@((kScreenWidth -200)/2));
        }];
        _resultlabel.text = @"工作已结束";
        [self resultShow];
    }
    // 设置图片大小
    attch.bounds = CGRectMake(0, 0, 55, 15);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attch];
    [taskNameAttrStr appendAttributedString:attachString];
    _contentTitle.attributedText = taskNameAttrStr;
    _statueImage.hidden = YES;
}

- (void)resultShow {
    _resultlabel.hidden = NO;
    _leftlabel.hidden = YES;
    _rightDay.hidden = YES;
    _dayButton.hidden = YES;
}
- (void)resultHiden {
    _resultlabel.hidden = YES;
    _leftlabel.hidden = NO;
    _rightDay.hidden = NO;
    _dayButton.hidden = NO;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
