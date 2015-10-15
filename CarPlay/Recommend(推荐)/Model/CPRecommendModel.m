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
    NSString *city = _destination[@"city"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" [%@] ",city] attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"fe5966"]}];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:_title attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"333333"]}];
    [str appendAttributedString:title];
   
    _titleAttrText = [str copy];
}

@end
