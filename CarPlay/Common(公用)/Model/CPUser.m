//
//  CPUser.m
//  CarPlay
//
//  Created by chewan on 9/25/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPUser.h"
#import "CPAlbum.h"

@implementation CPUser

- (void)setGender:(NSString *)gender
{
    _gender = gender;
    if ([gender isEqualToString:@"男"]) {
        _isMan = YES;
    }else{
        _isMan = NO;
    }
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"album":[CPAlbum class]};
}

- (void)setDistance:(NSUInteger)distance
{
    _distance = distance;
    
    if (_distance >= 1000) {
        CGFloat dis = distance / 1000.0;
        _distanceStr = [NSString stringWithFormat:@"%.1fkm",dis];
    }else{
        _distanceStr = [NSString stringWithFormat:@"%zdm",distance];
    }
}


MJCodingImplementation

@end
