//
//  CPHomeMsgModel.m
//  CarPlay
//
//  Created by chewan on 15/8/17.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHomeMsgModel.h"

@implementation CPHomeMsgModel

- (void)setContent:(NSString *)content
{
    _content = [content copy];
    NSString *text = [content stringByAppendingString:@"活动"];
    NSAttributedString *activityName = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"48d1d5"]}];
    
    NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithString:@"您已成功加入"];
    [msg appendAttributedString:activityName];
    _contentAttr = msg;
}

- (void)setCreateTime:(NSTimeInterval)createTime
{
    _createTime = createTime;
    
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
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:createTime / 1000];
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
            _timeStr = @"昨天";
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                fmt.dateFormat = @"HH:mm";
                _timeStr = [fmt stringFromDate:createDate];;
            } else if (cmps.minute >= 1) {
                _timeStr = [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                _timeStr = @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd";
            _timeStr = [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"MM-dd";
        _timeStr = [fmt stringFromDate:createDate];
    }

}

@end
