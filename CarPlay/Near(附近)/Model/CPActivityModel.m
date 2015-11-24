//
//  CPActivityModel.m
//  CarPlay
//
//  Created by chewan on 9/25/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityModel.h"

@implementation CPActivityModel

- (void)setDestination:(NSDictionary *)destination
{
    if ([destination isKindOfClass:[NSDictionary class]]) {
        _destination = destination;
    }
}

-(void)setDestabPoint:(NSDictionary *)destabPoint
{
    if ([destabPoint isKindOfClass:[NSDictionary class]]) {
        _destabPoint = destabPoint;
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
        _distanceStr = [NSString stringWithFormat:@"%.0fm",distance];
    }
}


@end
