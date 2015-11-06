//
//  CPActivityModel.m
//  CarPlay
//
//  Created by chewan on 9/25/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityModel.h"
#import "NSObject+Copying.h"

@implementation CPActivityModel

- (void)setDestination:(NSDictionary *)destination
{
    if ([destination isKindOfClass:[NSDictionary class]]) {
        _destination = destination;
    }
}

- (void)setOrganizer:(CPUser *)organizer
{
    if ([organizer isKindOfClass:[CPUser class]]) {
        _organizer = organizer;
    }
}

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@想找人%@",_organizer.nickname, _type];
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
