//
//  CPActivityModel.m
//  CarPlay
//
//  Created by chewan on 9/25/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityModel.h"

@implementation CPActivityModel

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@想邀请你%@",_organizer.nickname, _type];
}

@end
