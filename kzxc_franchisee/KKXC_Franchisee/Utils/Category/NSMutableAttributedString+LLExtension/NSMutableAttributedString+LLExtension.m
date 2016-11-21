//
//  NSMutableAttributedString+LLExtension.m
//  Coach
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "NSMutableAttributedString+LLExtension.h"

@implementation NSMutableAttributedString (LLExtension)

+ (NSMutableAttributedString *)attributeStringWithText:(NSString *)text attributes:(NSArray *)attArr
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    if (text)
    {
        [attStr appendText:text withAttributesArr:attArr];
    }
    return attStr;
}

+ (NSMutableAttributedString *)attributeStringWithImg:(UIImage *)img bounds:(CGRect)bounds
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    if (img)
    {
        [attStr appendImg:img bounds:bounds];
    }
    return attStr;
}

//添加文本
- (void)appendText:(NSString  *)text withAttributesArr:(NSArray *)attributesArr
{
    if (!text) {
        return;
    }
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    for (id value in attributesArr) {
        if ([value isKindOfClass:[NSNumber class]]) {
            if ([value isEqualToNumber:@(NSMutableAttributedStringExtensionTypeUnderline)]) {
                [mutDic setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
            }
            else if([value isEqualToNumber:@(NSMutableAttributedStringExtensionTypeLineThrough)])
            {
                [mutDic setObject:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
            }
            else
            {
                [mutDic setObject:[UIFont systemFontOfSize:[value floatValue]] forKey:NSFontAttributeName];
            }
        }
        else if([value isKindOfClass:[UIColor class]])
        {
            [mutDic setObject:value forKey:NSForegroundColorAttributeName];
        }
        else if([value isKindOfClass:[UIFont class]])
        {
            [mutDic setObject:value forKey:NSFontAttributeName];
        }
        else if([value isKindOfClass:[NSDictionary class]])
        {
            for (NSString *key in (NSDictionary *)value) {
                [mutDic setObject:value[key] forKey:key];
            }
        }
        else
        {
            
        }
    }
    
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:(!isNull(text)&&[text isKindOfClass:[NSString class]])?text:@"" attributes:mutDic]];
}

//添加图片
- (void)appendImg:(UIImage *)img bounds:(CGRect)bounds
{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = img;
    attachment.bounds = bounds;
    [self appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
}

//添加换行符
- (void)appendBreakLineWithInterval:(CGFloat)interval
{
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:interval]}]];
}

@end
