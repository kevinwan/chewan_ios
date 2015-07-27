//
//  CPMypublishModel.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMySubscribeModel.h"
#import "MJExtension.h"
#import "NSDate+Extension.h"
#import "HMPhoto.h"

@implementation CPMySubscribeModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"members" : [CPOrganizer class], @"cover" : [HMPhoto class]};
}

- (void)setStart:(long long)start
{
    _start = start;
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:start / 1000];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];

    fmt.dateFormat = @"MM月dd日 HH:mm";
    self.startStr = [fmt stringFromDate:currentDate];
}

- (NSString *)publishTimeStr
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:_publishTime / 1000];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

- (NSString *)seatStr
{
    return [NSString stringWithFormat:@"%zd/%zd",_holdingSeat, _totalSeat];
}

@end

@implementation CPOrganizer

- (void)setGender:(NSString *)gender
{
    _gender = [gender copy];
    self.isMan = [gender isEqualToString:@"男"] ? YES : NO;
}

- (NSString *)descStr
{
    return [NSString stringWithFormat:@"%@ %zd年驾龄",@"China", _drivingExperience];
}

@end