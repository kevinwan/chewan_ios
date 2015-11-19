//
//  CPCareUser.m
//  CarPlay
//
//  Created by 公平价 on 15/9/28.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPCareUser.h"

@implementation CPCareUser

- (void)setCar:(CPCar *)car
{
    if ([car isKindOfClass:[CPCar class]]) {
        _car = car;
    }
}
@end
