//
//  KZCircleShowNumView.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/20.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZCircleShowNumView : UIView

@property (nonatomic,strong) UILabel *circleLbl;

@property (nonatomic,strong) UILabel *promptLbl;

- (void)setShowNum:(NSString *)num;

@end
