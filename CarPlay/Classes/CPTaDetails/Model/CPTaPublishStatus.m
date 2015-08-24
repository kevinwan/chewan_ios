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
#import "CPHomeMember.h"

#define MaxMemberCount 4
@implementation CPTaPublishStatus

// 数组转模型
+ (NSDictionary *)objectClassInArray{
    return @{@"cover":[CPTaPhoto class],@"members":[CPTaMember class]};
}

- (void)setMembers:(NSArray *)members{
    
    _membersCount = members.count;
    NSInteger count = members.count > MaxMemberCount ? MaxMemberCount : members.count;
    NSMutableArray *tempMembers = [NSMutableArray arrayWithArray:[members subarrayWithRange:NSMakeRange(0, count)]];
    
    CPHomeMember *homeMember = [[CPHomeMember alloc] init];
    homeMember.membersCount = count;
    homeMember.photo = @"用户小头像底片";
    [tempMembers addObject:homeMember];
    _members = tempMembers;
    
//    return;
//    if (members.count < 5) {
//        // 临时头像列表
//        NSMutableArray *tempMembers = [NSMutableArray arrayWithArray:members];
//    }
//    
//    if (members.count >= 5) {
//        // 临时头像列表
//        NSMutableArray *tempMembers = [NSMutableArray arrayWithArray:[members subarrayWithRange:NSMakeRange(0, 4)]];
//        CPHomeMember *homeMember = [[CPHomeMember alloc] init];
//        homeMember.membersCount = members.count;
//        homeMember.photo = @"用户小头像底片";
//        [tempMembers addObject:homeMember];
//        _members = tempMembers;
//        
//    }
//    
}


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

// 活动时间转为字符串
- (NSString *)startStr{
    
    // 将服务器返回时间转换为NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    // 将时间戳转换为NSDate
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:_start / 1000];
    // 返回活动时间字符串
    return [formatter stringFromDate:startDate];
    
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
