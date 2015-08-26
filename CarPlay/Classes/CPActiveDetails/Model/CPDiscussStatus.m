//
//  CPDiscussStatus.m
//  CarPlay
//
//  Created by 公平价 on 15/7/23.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPDiscussStatus.h"

@implementation CPDiscussStatus

// 发布时间转为字符串
- (NSString *)publishTimeStr{
    
//    // 将服务器返回时间转换为NSDate
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // 如果是真机调试，转换这种欧美时间，需要设置locale
//    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
//    // 将时间戳转换为NSDate
//    NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:_publishTime / 1000];
//    
//    
//    if ([createdDate isThisYear]) {
//        // 今年
//        if ([createdDate isToday]) {
//            // 今天
//            NSDateComponents *cmps =[createdDate deltaWithNow];
//            if (cmps.hour >= 1) {
//                // 其它小时
//                return [NSString stringWithFormat:@"%tu小时前", cmps.hour];
//            }else if (cmps.minute > 1){
//                // 1小时以内
//                return [NSString stringWithFormat:@"%tu分钟前", cmps.minute];
//            }else
//            {
//                // 1分钟以内
//                return @"刚刚";
//            }
//            
//        }else if ([createdDate isYesterday]){
//            // 昨天
//            formatter.dateFormat = @"昨天 HH:mm";
//            return [formatter stringFromDate:createdDate];
//        }else{
//            // 其它天
//            formatter.dateFormat = @"MM-dd HH:mm";
//            return [formatter stringFromDate:createdDate];
//        }
//    }else
//    {
//        // 非今年
//        formatter.dateFormat = @"yy-MM-dd HH:mm";
//        return [formatter stringFromDate:createdDate];
//    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    
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
                return  [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"MM-dd";
        return [fmt stringFromDate:createDate];
    }
    
}

@end
