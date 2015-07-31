//
//  CPTaPublishStatus.m
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaPublishStatus.h"
#import "MJExtension.h"
#import "CPTaPhoto.h"
#import "CPTaMember.h"

@implementation CPTaPublishStatus

// 数组转模型
+ (NSDictionary *)objectClassInArray{
    return @{@"cover":[CPTaPhoto class],@"members":[CPTaMember class]};
}

@end
