//
//  CPMypublishModel.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMypublishModel.h"
#import "MJExtension.h"
#import "HMPhoto.h"
#import "CPMySubscribeModel.h"
@implementation CPMyPublishModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"members" : [CPOrganizer class], @"cover" : [HMPhoto class]};
}

- (void)setStartDate:(NSTimeInterval)startDate
{
    _startDate = startDate;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    _startDateStr = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:startDate / 1000]];
}

- (void)setPublishDate:(NSString *)publishDate
{
    NSArray *arr = [publishDate componentsSeparatedByString:@"."];
    int o = [[arr firstObject] intValue];
    int t = [[arr lastObject] intValue];
    _publishDate = [NSString stringWithFormat:@"%02d.%02d",o, t];
}

@end

