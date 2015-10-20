//
//  CPRecommendModel.m
//  CarPlay
//
//  Created by chewan on 10/10/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPRecommendModel.h"

@implementation CPRecommendModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"members" : [CPUser class]};
}

- (NSString *)desc
{
    return @"立方时空的角度看了解到发送垃圾爱的色放克里夫大师法律框架疯狂拉圣诞节快乐大厦积分卡拉斯的积分卡拉斯加对方看蓝精灵阿萨德路附近卡拉是大家发了卡仕达发了卡仕达交罚款垃圾的是否理科ADSL分记录卡上的房价可怜的双方家里看打扫房间了肯定撒风景克拉的双方家里卡上的飞机看来打发时间圣诞节快乐大厦积分卡拉斯的积分卡拉斯加对方看蓝精灵阿萨德路附近卡拉是大家发了卡仕达发了卡仕达交罚款垃圾的是否理科ADSL分记录卡上的房价可怜的双方家里看打扫房间了肯定撒风景克拉的双方家里卡上的飞机看来打发时间";
}

- (void)setStart:(long long)start
{
    _start = start;
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    _startStr = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:start / 1000]];
}

- (void)setEnd:(long long)end
{
    _end = end;
    
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = @"yyyy-MM-dd";
    _endStr = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:end / 1000]];
}

- (void)setPrice:(double)price
{
    _price = price;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f",price] attributes:@{NSFontAttributeName : ZYFont16, NSForegroundColorAttributeName : [Tools getColor:@"fe5966"]}];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"元/人" attributes:@{NSFontAttributeName : ZYFont12, NSForegroundColorAttributeName : [Tools getColor:@"666666"]}]];
    
    _priceText = [str copy];
}

- (void)setNowJoinNum:(NSUInteger)nowJoinNum
{
    _nowJoinNum = nowJoinNum;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"参与 " attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"999999"]}];
    NSAttributedString *num = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd",nowJoinNum] attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"333333"]}];
    [str appendAttributedString:num];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" 人" attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"999999"]}]];
    _joinPersonText = [str copy];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    if (_destination) {
        [self setTitleAttrbuteText];
    }
}

- (void)setDestination:(NSDictionary *)destination
{
    _destination = destination;
    
    if (_title.length) {
        [self setTitleAttrbuteText];
    }
}

- (void)setTitleAttrbuteText
{
    _title = @"离开的时间风口浪尖地方撒刻录机啊但是拉萨的会计法离开的撒娇了东风科技啊是阿双方的骄傲是发动机拉萨到家里的发生时空裂缝的家里大事件两款发动机阿里山的发生地方";
    NSString *city = _destination[@"city"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" [%@] ",city] attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"fe5966"]}];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:_title attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"333333"]}];
    [str appendAttributedString:title];
   
    _titleAttrText = [str copy];
}

- (NSString *)instruction
{
    return @"啊看来的时间考虑的是否健康来打发时间来看打发时间来看的方式了肯定撒风景拉斯加福利卡的是减肥了打扫房间大放送骄傲的发生了空间的罚款了巨大是法律进阿飞的说了句反倒是徕卡的时间来看打发时间来看打发时间看来大家看了都放假快乐的方式健康的法律纠纷的刻录机发哦ijfaifjifdjiadf流口水的纠纷可怜的方式三方登录科大附近时考虑将地方撒了";
}

- (NSString *)extraDesc
{
    return @"啊看来的时间考虑的是否健康来打发时间来看打发时间来看的方式了肯定撒风景拉斯加福利卡的是减肥了打扫房间大放送骄傲的发生了空间的罚款了巨大是法律进阿飞的说了句反倒是徕卡的时间来看打发时间来看打发时间看来大家看了都放假快乐的方式健康的法律纠纷的刻录机发哦ijfaifjifdjiadfsdf交水电费可骄傲的方式来看";
}

@end
