//
//  CPHomeStatus.m
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHomeStatus.h"
#import "MJExtension.h"
#import "CPHomePhoto.h"


@implementation CPHomeStatus

+ (NSDictionary *)objectClassInArray{
    return @{@"cover":[CPHomePhoto class]};
}

@end
