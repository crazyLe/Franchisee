//
//  KZMaterialsCollectionFooter.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KZMaterialsCollectionFooter;

@protocol KZMaterialsCollectionFooterDelegate <NSObject>

- (void)KZMaterialsCollectionFooter:(KZMaterialsCollectionFooter *)footer clickApplyBtn:(UIButton *)applyBtn;

@end

@interface KZMaterialsCollectionFooter : UICollectionReusableView

@property (nonatomic,assign) id <KZMaterialsCollectionFooterDelegate> delegate;

@end
