//
//  NSString+Size.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/28.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

+(CGSize)string:(NSString *)str sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
