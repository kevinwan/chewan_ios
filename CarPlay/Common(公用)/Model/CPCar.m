//
//  CPCar.m
//  CarPlay
//
//  Created by 公平价 on 15/10/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPCar.h"

@implementation CPCar
MJCodingImplementation

- (NSString *)model
{
    if (_model.length > 4) {
        return [[_model substringToIndex:4] stringByAppendingString:@".."];
    }
    return _model;
}
@end
