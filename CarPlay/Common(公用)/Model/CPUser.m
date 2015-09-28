//
//  CPUser.m
//  CarPlay
//
//  Created by chewan on 9/25/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPUser.h"

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

@end
