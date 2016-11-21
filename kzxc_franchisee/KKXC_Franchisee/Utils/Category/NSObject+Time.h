//
//  NSObject+Time.h
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/8/8.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Time)
/**
 *  当前时间转换为时间戳
 *
 *  @return 时间戳字符串
 */
-(NSString *)getcurrentTime;
/**
 *  时间戳转时间
 *
 *  @param timestr 时间戳
 *
 *  @return 时间字符串
 */
- (NSString *)getStamptimeWithString:(NSString *)timestr andSec:(int)state;
/**
 *  时间转时间戳
 */
- (NSString *)getStamptimeWithTime:(NSString *)str;

//获取当前时间的年月(格式2016-10)
- (NSString *)getYearMonthTime;

@end
