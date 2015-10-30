//
//  CPIntersterModel.h
//  CarPlay
//
//  Created by chewan on 10/24/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPIntersterModel : NSObject<NSCopying>

@property (nonatomic, copy) NSString *relatedId;
@property (nonatomic, strong) CPUser *user;

@property (nonatomic, strong) NSDictionary *activityDestination;
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *activityPay;
@property (nonatomic, copy) NSString *activityType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL  activityTransfer;
@property (nonatomic, assign) NSInteger photoCount;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) double distance;
@property (nonatomic, copy, readonly) NSString *distanceStr;
@property (nonatomic, copy) NSString *title;
@end
