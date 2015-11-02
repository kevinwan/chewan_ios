//
//  CPRecommendModel.m
//  CarPlay
//
//  Created by chewan on 10/10/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPRecommendModel.h"
#import "NSDate+Category.h"

@implementation CPRecommendModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"members" : [CPPartMember class]};
}

- (NSString *)desc
{
    if (_desc.trimLength) {
        return _desc;
    }
    return @"";
}

- (void)setCovers:(NSArray *)covers
{
    if ([covers isKindOfClass:[NSArray class]]) {
        _covers = covers;
    }
}

- (void)setCreateTime:(long long)createTime
{
    _createTime = createTime;
    _createTimeStr = [NSDate formattedTimeFromTimeInterval:createTime / 1000];
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
    
    if (end) {
        
        NSDateFormatter *format = [NSDateFormatter new];
        format.dateFormat = @"yyyy-MM-dd";
        _endStr = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:end / 1000]];
    }else{
        _endStr = @"待定";
    }
}

- (void)setPrice:(double)price
{
    _price = price;
    
    if (price){
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f",price] attributes:@{NSFontAttributeName : ZYFont16, NSForegroundColorAttributeName : [Tools getColor:@"fe5966"]}];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"元/人" attributes:@{NSFontAttributeName : ZYFont12, NSForegroundColorAttributeName : [Tools getColor:@"666666"]}]];
        
        _priceText = [str copy];
    }else{
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"免费" attributes:@{NSFontAttributeName : ZYFont16, NSForegroundColorAttributeName : [Tools getColor:@"fe5966"]}];
        
        _priceText = [str copy];
    }
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
    NSString *city = _destination[@"city"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" [%@] ",city] attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"fe5966"]}];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",_title] attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"333333"]}];
//     NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"姐姐姐姐姐姐姐姐姐姐谁谁谁水水水水谁谁谁哦哦哦哦哦哈哈哈哈哈呃呃呃是姐姐姐姐姐姐姐姐"] attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"333333"]}];
    
    [str appendAttributedString:title];
    _titleAttrText = [str copy];
}

@end

@implementation CPPartMember

+ (NSDictionary *)objectClassInArray
{
    return @{@"acceptMembers" : [CPUser class]};
}

- (void)setBeInvitedCount:(NSUInteger)beInvitedCount
{
    _beInvitedCount = beInvitedCount;
    
    NSMutableAttributedString *invitedStr = [[NSMutableAttributedString alloc] initWithString:@"已被" attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"999999"]}];
    NSAttributedString *countStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd人",beInvitedCount] attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"fe5967"]}];
    NSAttributedString *lastStr = [[NSAttributedString alloc] initWithString:@"邀请同去" attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"999999"]}];
    [invitedStr appendAttributedString:countStr];
    [invitedStr appendAttributedString:lastStr];
    _invitedCountStr = [invitedStr copy];
}

@end