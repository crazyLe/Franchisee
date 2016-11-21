//
//  UIButton+KZExtension.h
//  KKXC_Franchisee
//
//  Created by LL on 16/10/21.
//  Copyright © 2016年 cqingw. All rights reserved.
//

typedef enum {
    LLButtonStyleTextOnly = 1, //只显示文字
    LLButtonStyleImgOnly,      //只显示图片
    LLButtonStyleTextLeft,     //文字在左，图片在右
    LLButtonStyleTextRight,    //文字在右，图片在左
    LLButtonStyleTextTop,      //文字在上，图片在下
    LLButtonStyleTextBottom    //文字在下，图片在上
}LLButtonStyle;

#import <UIKit/UIKit.h>

@interface UIButton (KZExtension)

//调用这个方法前，必须先设置好button的image和title/attributedtitle 要不然无法生效
- (void)layoutButtonWithEdgeInsetsStyle:(LLButtonStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
