//
//  CPMyDateModel.m
//  CarPlay
//
//  Created by chewan on 10/23/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPMyDateModel.h"

@implementation CPMyDateModel
- (void)setDestination:(NSDictionary *)destination
{
    if ([destination isKindOfClass:[NSDictionary class]]) {
        _destination = destination;
    }
}

- (void)setApplicant:(CPUser *)applicant
{
    if ([applicant isKindOfClass:[CPUser class]]) {
        _applicant = applicant;
    }
}

- (NSAttributedString *)title
{
    if ([_activityCategory isEqualToString:@"邀请同去"]) {
        NSString *typeS = nil;
        if (_type.length>5) {
            typeS = [_type substringToIndex:5];
        }else{
            typeS = _type;
        }
        if (_isApplicant){
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我想邀%@同去",_applicant.nickname]];
            NSAttributedString *append = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_type] attributes:@{NSForegroundColorAttributeName : RedColor}];
            [str appendAttributedString:append];
            
            [str addAttributes:@{NSFontAttributeName : ZYFont16} range:NSMakeRange(0, str.length)];
            return [str copy];
        }else{
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@想邀我同去",_applicant.nickname]];
            NSAttributedString *append = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_type] attributes:@{NSForegroundColorAttributeName : RedColor}];
            [str appendAttributedString:append];
            [str addAttributes:@{NSFontAttributeName : ZYFont16} range:NSMakeRange(0, str.length)];
            return [str copy];
        }
    }
    
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@想找人一块%@",_applicant.nickname, _type]];
}
- (void)setDistance:(double)distance
{
    _distance = distance;
    
    if (distance == 0.0){
        _distanceStr = @"未知";
        return;
    }
    
    if (_distance >= 1000) {
        CGFloat dis = distance / 1000.0;
        _distanceStr = [NSString stringWithFormat:@"%.1fkm",dis];
    }else{
        _distanceStr = [NSString stringWithFormat:@"%.1fm",distance];
    }
}
@end
