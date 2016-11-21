//
//  KZWorkCollegeCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZArticleModel.h"
#import "KZWorkCollegeCell.h"

@implementation KZWorkCollegeCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setArticleModel:(KZArticleModel *)articleModel{
    if (_articleModel != articleModel) {
        _articleModel = articleModel;
        
        _titleLbl.text = _articleModel.articleTitle;
        _contentLbl.text = _articleModel.articleRemark;
        
        [_rightImgView sd_setImageWithURL:[NSURL URLWithString:[_articleModel.articleImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        switch ([_articleModel.articleType intValue]) {
            case 1:
            {
                //文章
                _flagLbl.text = @"文章";
                _flagLbl.backgroundColor = [UIColor colorWithHexString:@"1d8fe1"];
            }
                break;
            case 2:
            {
                //视频
                _flagLbl.text = @"视频";
                _flagLbl.backgroundColor = [UIColor colorWithHexString:@"ff801a"];
            }
                break;
            case 3:
            {
                //图片
                _flagLbl.text = @"图片";
                _flagLbl.backgroundColor = [UIColor colorWithHexString:@"ff801a"];
            }
                break;
                
            default:
                break;
        }
        
    }
}

@end
