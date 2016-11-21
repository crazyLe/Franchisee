//
//  NSString+Hash.h
//  醉了么
//
//  Created by zuweizhong  on 16/6/3.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)
/**
 *  32位MD5加密方式(小写)
 *
 *  @param srcString 加密前字符串
 *
 *  @return 加密后字符串
 */
+ (NSString *)get32BitMD5_lowercaseString:(NSString *)srcString;
/**
 *  16位MD5加密方式(提取md5散列中的16位就行)(小写)
 *
 *  @param srcString 加密前字符串
 *
 *  @return 加密后字符串
 */
+ (NSString *)get16BitMD5_lowercaseString:(NSString *)srcString;

/**
 *  32位MD5加密方式(大写)
 *
 *  @param srcString 加密前字符串
 *
 *  @return 加密后字符串
 */
+ (NSString *)get32BitMD5_uppercaseString:(NSString *)srcString;
/**
 *  16位MD5加密方式(提取md5散列中的16位就行)(大写)
 *
 *  @param srcString 加密前字符串
 *
 *  @return 加密后字符串
 */
+ (NSString *)get16BitMD5_uppercaseString:(NSString *)srcString;

@end
