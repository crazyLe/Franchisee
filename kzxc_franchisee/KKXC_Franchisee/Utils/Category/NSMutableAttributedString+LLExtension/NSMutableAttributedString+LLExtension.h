//
//  NSMutableAttributedString+LLExtension.h
//  Coach
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NSMutableAttributedStringExtensionTypeUnderline = 100, //下划线
    NSMutableAttributedStringExtensionTypeLineThrough      //删除线
}NSMutableAttributedStringExtensionType;

@interface NSMutableAttributedString (LLExtension)

//初始化并添加文本
+ (NSMutableAttributedString *)attributeStringWithText:(NSString *)text attributes:(NSArray *)attArr;

//初始化并添加图片
+ (NSMutableAttributedString *)attributeStringWithImg:(UIImage *)img bounds:(CGRect)bounds;

//添加文本
- (void)appendText:(NSString  *)text withAttributesArr:(NSArray *)attributesArr;
//添加图片
- (void)appendImg:(UIImage *)img bounds:(CGRect)bounds;
//添加换行符
- (void)appendBreakLineWithInterval:(CGFloat)interval;


@end
