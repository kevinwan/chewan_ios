//
//  CPUserTool.h
//  CarPlay
//
//  Created by chewan on 10/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPUserTool : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, strong) CPUser *user;
@end
