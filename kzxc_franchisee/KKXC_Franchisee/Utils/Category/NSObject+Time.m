//
//  NSObject+Time.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/8/8.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "NSObject+Time.h"

@implementation NSObject (Time)

- (NSString *)getcurrentTime
{
    // 当前时间
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    
    return timeString;
}

- (NSString *)getStamptimeWithString:(NSString *)timestr andSec:(int)state
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    switch (state) {
        case 0:
        {
            [formatter setDateFormat:@"yyyy/MM/dd"];
        }
            break;
        case 1:
        {
            [formatter setDateFormat:@"MM/dd/ HH:mm"];
        }
            break;
        case 2:
        {
            [formatter setDateFormat:@"yyyy/MM/dd/ HH:mm:ss"];
        }
            break;
        case 3:
        {
            [formatter setDateFormat:@"yyyy/MM"];
        }
            break;
        case 4:
        {
            [formatter setDateFormat:@"yyyy/MM/dd/ HH:mm"];
        }
            break;
        default:
            break;
    }

    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestr.longLongValue];

    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (NSString *)getStamptimeWithTime:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    
    NSDate* date = [formatter dateFromString:str];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}
//获取当前时间的年月(格式2016-10)
- (NSString *)getYearMonthTime {
    
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString * yearMonthDate = [dateFormatter stringFromDate:mydate];
    return yearMonthDate;
    
}
@end
