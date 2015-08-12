//
//  CPTaPublishStatus.m
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaPublishStatus.h"
#import "MJExtension.h"
#import "CPTaPhoto.h"
#import "CPTaMember.h"

@implementation CPTaPublishStatus

// 数组转模型
+ (NSDictionary *)objectClassInArray{
    return @{@"cover":[CPTaPhoto class],@"members":[CPTaMember class]};
}

- (void)setStartDate:(long long)startDate{
    _startDate = startDate;
    // 将服务器返回时间转换为NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    // 将时间戳转换为NSDate
    NSDate *start = [NSDate dateWithTimeIntervalSince1970:startDate / 1000];
    // 返回活动时间字符串
    _startDateStr = [formatter stringFromDate:start];
}



@end
