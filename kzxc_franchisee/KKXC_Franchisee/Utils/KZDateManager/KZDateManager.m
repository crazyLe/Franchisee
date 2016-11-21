//
//  KZDateManager.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZDateManager.h"

@implementation KZDateManager

//将时间戳转换成NSDate
//timeStamp  : 时间戳 NSString / NSNumber
//return     : 返回对应的日期 NSDate
+ (NSDate *)dateWithTimeStamp:(id)timeStamp
{
    if (isNull(timeStamp)) {
        return [NSDate date];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    if (isNull(date)) {
        return [NSDate date];
    }
    else
    {
        return date;
    }
}

//将时间戳转换成NSString
//timeStamp  : 时间戳 NSString / NSNumber
//dateFormat : 返回的时期格式 eg. @"yyyy-MM-dd"
//return     : 返回对应的日期字符串 NSString
+ (NSString *)dateStrWithTimeStamp:(id)timeStamp dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = isNull(dateFormat)?@"yyyy-MM-dd":dateFormat;
    if (isNull(timeStamp)) {
        return [dateFormater stringFromDate:[NSDate date]];
    }
    NSDate *date = [self dateWithTimeStamp:timeStamp];
    NSString *dateStr = [dateFormater stringFromDate:date];
    if (isNull(dateStr)) {
        return [dateFormater stringFromDate:[NSDate date]];
    }
    else
    {
        return dateStr;
    }
}

//将日期转换成 制定格式的日期字符串
//date       : 待转换日期 NSDate
//dateFormat : 返回的时期格式 eg. @"yyyy-MM-dd"
//return     : 返回对应的日期字符串 NSString
+ (NSString *)dateStrWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = isNull(dateFormat)?@"yyyy-MM-dd":dateFormat;
    if (isNull(date)) {
        return [dateFormater stringFromDate:[NSDate date]];
    }
    NSString *dateStr = [dateFormater stringFromDate:date];
    if (isNull(dateStr)) {
        return [dateFormater stringFromDate:[NSDate date]];
    }
    else
    {
        return dateStr;
    }
}

//将日期字符串 按照相应的格式 转换成对应的 日期
//dateStr    : 待转换日期字符串 NSString
//dateFormat : 返回的时期格式 eg. @"yyyy-MM-dd"  注意：dateFormat参数传入的字符串格式必须和传入的dateStr的格式一致，否则会崩溃!
//return     : 返回对应的日期 NSDate
+ (NSDate *)dateWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = isNull(dateFormat)?@"yyyy-MM-dd":dateFormat;
    if (isNull(dateStr)) {
        return [NSDate date];
    }
    NSDate *date = [dateFormater dateFromString:dateStr];
    if (isNull(date)) {
        return [NSDate date];
    }
    else
    {
        return date;
    }
}

//获取对应日期的时间戳
//date   : NSDate
//return : 时间戳
+ (long long)timestampsWithDate:(NSDate *)date
{
    if (isNull(date)) {
        return [[NSDate date] timeIntervalSince1970];
    }
    long long timestamps = [date timeIntervalSince1970];
    if (timestamps<0) {
        return [[NSDate date] timeIntervalSince1970];
    }
    else
    {
        return timestamps;
    }
}

//获取对应日期字符串的时间戳
//dateStr   : NSString
//format    :格式化的字符串
//return    : 时间戳
+ (long long)timestampsWithDateStr:(NSString *)dateStr dateFormat:(NSString *)format
{
    if (isNull(dateStr)) {
        return [[NSDate date] timeIntervalSince1970];
    }
    NSDate *date = [self dateWithDateStr:dateStr dateFormat:format];
    long long timestamps = [self timestampsWithDate:date];
    return timestamps;
}

@end
