//
//  CPLocalActivityModel.h
//  CarPlay
//
//  Created by chewan on 15/8/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPCreatActivityModelTool.h"
#import "CPCreatActivityModel.h"
@class CPLocalActivityModel;
@interface CPCreatActivityModelTool : NSObject

+ (void)save:(CPLocalActivityModel *)model;

+ (CPLocalActivityModel *)getLocalModel;

+ (NSDictionary *)paramsWithLocalModel:(CPLocalActivityModel *)model;

@end


@interface CPLocalActivityModel : CPCreatActivityModel

@property (nonatomic, strong) NSMutableArray *imageNames;

@end
