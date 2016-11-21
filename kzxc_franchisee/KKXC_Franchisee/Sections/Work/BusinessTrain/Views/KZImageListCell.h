//
//  KZImageListCell.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/22.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZImageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@property (weak, nonatomic) IBOutlet UILabel *imgNumLbl;

/**
 设置图片的url
 */
- (void)setImgWithImageUrlStr:(NSString *)imageUrlStr;

@end
