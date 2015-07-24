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
    
    // 将服务器返回时间转换为NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    // 将时间戳转换为NSDate
    NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:_publishTime / 1000];
    
    
    if ([createdDate isThisYear]) {
        // 今年
        if ([createdDate isToday]) {
            // 今天
            NSDateComponents *cmps =[createdDate deltaWithNow];
            if (cmps.hour >= 1) {
                // 其它小时
                return [NSString stringWithFormat:@"%tu小时前", cmps.hour];
            }else if (cmps.minute > 1){
                // 1小时以内
                return [NSString stringWithFormat:@"%tu分钟前", cmps.minute];
            }else
            {
                // 1分钟以内
                return @"刚刚";
            }
            
        }else if ([createdDate isYesterday]){
            // 昨天
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:createdDate];
        }else{
            // 其它天
            formatter.dateFormat = @"MM-dd HH:mm";
            return [formatter stringFromDate:createdDate];
        }
    }else
    {
        // 非今年
        formatter.dateFormat = @"yy-MM-dd HH:mm";
        return [formatter stringFromDate:createdDate];
    }
    
}

@end
