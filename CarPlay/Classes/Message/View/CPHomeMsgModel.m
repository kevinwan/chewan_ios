//
//  CPHomeMsgModel.m
//  CarPlay
//
//  Created by chewan on 15/8/17.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHomeMsgModel.h"

@implementation CPHomeMsgModel

- (void)setType:(NSString *)type
{
    _type = [type copy];
    
    if (_content.length) {
        [self setContentAttrText];
    }
}

/**
 *  设置拼接好的属性文字
 */
- (void)setContentAttrText
{
    NSAttributedString *head;
    NSAttributedString *middle = [[NSAttributedString alloc] initWithString:_content attributes:@{NSForegroundColorAttributeName :[Tools getColor:@"48d1d5"]}];
    NSAttributedString *footer;
    if ([_type isEqualToString:@"车主认证"]) { // 车主认证
        head = [[NSAttributedString alloc] initWithString:@"你提交的"];
        
    }else if ([_type isEqualToString:@"活动邀请"]){ // 活动邀请
        head = [[NSAttributedString alloc] initWithString:@"邀您加入"];
        footer = [[NSAttributedString alloc] initWithString:@"活动"];
    }else if ([_type isEqualToString:@"活动申请结果"]){ //活动申请结果
        head = [[NSAttributedString alloc] initWithString:@"活动申请: "];
        footer = [[NSAttributedString alloc] initWithString:@"同意您的申请"];
    }else if ([_type isEqualToString:@"活动申请处理"]){
        head = [[NSAttributedString alloc] initWithString:@"想加入"];
        footer = [[NSAttributedString alloc] initWithString:@"活动"];
    }else{
        _contentAttr = [[NSAttributedString alloc] initWithString:@"带我飞"];;
        return;
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    [text appendAttributedString:head];
    [text appendAttributedString:middle];
    if (footer) {
        [text appendAttributedString:footer];
    }
    _contentAttr = text;
}

- (void)setContent:(NSString *)content
{
    _content = [content copy];
    
    if (_type.length) {
        [self setContentAttrText];
    }
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
