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
    return [NSString stringWithFormat:@"%@想邀请你%@",_applicant.nickname, _type];
}

@end
