//
//  cars.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/20.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import "cars.h"

@implementation cars
//将字典里的数组元素转模型
+ (NSDictionary*)objectClassInArray {
    return @{@"users":[users class]};
}
@end
