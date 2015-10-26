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

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@想找人一块%@",_applicant.nickname, _type];
}
- (void)setDistance:(double)distance
{
    _distance = distance;
    
    if (_distance >= 1000) {
        CGFloat dis = distance / 1000.0;
        _distanceStr = [NSString stringWithFormat:@"%.1fkm",dis];
    }else{
        _distanceStr = [NSString stringWithFormat:@"%.1fm",distance];
    }
}
@end
