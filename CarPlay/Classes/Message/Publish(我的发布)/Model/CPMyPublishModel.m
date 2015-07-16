//
//  CPMypublishModel.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMypublishModel.h"
#import "NSDate+Extension.h"
#import "MJExtension.h"
#import "HMPhoto.h"
#import "CPMySubscribeModel.h"
@implementation CPMyPublishModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"members" : [CPOrganizer class], @"cover" : [HMPhoto class]};
}

- (void)setStart:(long long)start
{
    _start = start;
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:start / 1000];
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
    fmt.dateFormat = @"MM月dd日";
    self.startStr = [fmt stringFromDate:currentDate];
}

- (void)setPublishTime:(long long)publishTime
{
    _publishTime = publishTime;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM.dd";
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:publishTime / 1000];
    self.publishTimeStr = [fmt stringFromDate:createDate];
}

@end

