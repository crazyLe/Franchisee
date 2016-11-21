//
//  UIImage+Helper.h
//  KZXC_Instructor
//
//  Created by 翁昌青 on 16/6/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)
/**
 *  祛除图片渲染效果
 *
 *  @param imgName 图片名称
 *
 *  @return 返回无渲染图片本身
 */
+ (UIImage *)imageWithRenderingMode:(NSString *)imgName;
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
