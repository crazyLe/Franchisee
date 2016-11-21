//
//  KZImageListCell.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZImageListCell.h"

@implementation KZImageListCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

/**
设置图片的url
 */
- (void)setImgWithImageUrlStr:(NSString *)imageUrlStr{
    NSArray *imgUrlArr = [imageUrlStr componentsSeparatedByString:@"|"];
    NSArray *imgViewArr = @[self.leftImgView,self.centerImgView,self.rightImgView];
    for (int i = 0; i < imgUrlArr.count; i++) {
        if (i>2) {
            break;
        }
        [imgViewArr[i] sd_setImageWithURL:[NSURL URLWithString:[imgUrlArr[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                self.imageView.image = [UIImage imageNamed:@"placeholder"];
            }
        }];
    }
}

@end
