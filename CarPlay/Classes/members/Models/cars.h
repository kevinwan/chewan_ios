//
//  cars.h
//  参与成员
//
//  Created by Jia Zhao on 15/7/20.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "users.h"

@interface cars : NSObject
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, copy) NSString *totalSeat;
@property (nonatomic, copy) NSString *carBrandLogo;
@property (nonatomic, copy) NSString *carModel;
@property (nonatomic, copy) NSArray *users;

@end
