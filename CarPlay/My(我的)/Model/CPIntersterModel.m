//
//  CPIntersterModel.m
//  CarPlay
//
//  Created by chewan on 10/24/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPIntersterModel.h"

@implementation CPIntersterModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"activityId" : @"id"};
}

- (void)setActivityDestination:(NSDictionary *)activityDestination
{
    if ([activityDestination isKindOfClass:[NSDictionary class]]) {
        _activityDestination = activityDestination;
    }
}

- (void)setUser:(CPUser *)user
{
    if ([user isKindOfClass:[CPUser class]]) {
        _user = user;
    }
}
- (NSString *)title
{
    return [NSString stringWithFormat:@"%@想找人一块%@",_user.nickname, _activityType];
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
