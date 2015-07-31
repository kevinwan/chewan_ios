//
//  CPTaDetailsStatus.m
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaDetailsStatus.h"
#import "MJExtension.h"
#import "CPTaPhoto.h"

@implementation CPTaDetailsStatus

+ (NSDictionary *)objectClassInArray{
    return @{@"albumPhotos":[CPTaPhoto class]};
}

@end
