//
//  CPOfficialActivity.m
//  CarPlay
//
//  Created by 公平价 on 15/8/18.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPOfficialActivity.h"

@implementation CPOfficialActivity

- (void)setEnd:(long long)end{
    _end = end;
    // 将服务器返回时间转换为NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy.MM.dd";
    // 将时间戳转换为NSDate
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:_end / 1000];
    // 返回活动时间字符串
    _endStr = [formatter stringFromDate:startDate];
}


@end
