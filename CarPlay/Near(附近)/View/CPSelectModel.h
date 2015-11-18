//
//  CPSelectModel.h
//  CarPlay
//
//  Created by chewan on 10/12/15.
//  Copyright © 2015 chewan. All rights reserved.
//  筛选model

#import <Foundation/Foundation.h>

@interface CPSelectModel : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pay;
@property (nonatomic, assign) NSInteger  transfer;
@property (nonatomic, copy) NSString *sex;

@end
