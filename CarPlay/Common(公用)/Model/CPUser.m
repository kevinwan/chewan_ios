//
//  CPUser.m
//  CarPlay
//
//  Created by chewan on 9/25/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPUser.h"
#import "CPAlbum.h"
#import "NSObject+Copying.h"

@implementation CPUser
MJCopyingImplemention
- (void)setGender:(NSString *)gender
{
    _gender = gender;
    if ([gender isEqualToString:@"男"]) {
        _isMan = YES;
    }else{
        _isMan = NO;
    }
}

- (void)setCar:(CPCar *)car
{
    if ([car isKindOfClass:[CPCar class]]) {
        _car = car;
    }
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"album":[CPAlbum class]};
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



MJCodingImplementation

@end
