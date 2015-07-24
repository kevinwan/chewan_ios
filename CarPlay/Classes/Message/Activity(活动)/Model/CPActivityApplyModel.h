//
//  CPActivityApplyModel.h
//  CarPlay
//
//  Created by chewan on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPActivityApplyModel : NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *seat;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *applicationId;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *carBrandLogo;
@end
