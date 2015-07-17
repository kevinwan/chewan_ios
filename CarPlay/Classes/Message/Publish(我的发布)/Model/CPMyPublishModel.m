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

