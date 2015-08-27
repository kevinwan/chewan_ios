//
//  CPLocalActivityModel.m
//  CarPlay
//
//  Created by chewan on 15/8/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPCreatActivityModelTool.h"
#define CPCreatActivityModelPath CPDocmentPath([[Tools getValueFromKey:@"userId"] stringByAppendingString:@"creatModel.data"])
@implementation CPCreatActivityModelTool

+ (void)save:(CPLocalActivityModel *)model
{
    // 异步存储 加强用户体验
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSKeyedArchiver archiveRootObject:model toFile:CPCreatActivityModelPath];
    });
}

+ (CPLocalActivityModel *)getLocalModel
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:CPCreatActivityModelPath];
}

+ (NSDictionary *)paramsWithLocalModel:(CPLocalActivityModel *)model
{
    CPCreatActivityModel *creatModel = [CPCreatActivityModel objectWithKeyValues:[model keyValues]];
    return [creatModel keyValues];
}

@end

@implementation CPLocalActivityModel

MJCodingImplementation

- (NSMutableArray *)imageNames
{
    if (_imageNames == nil) {
        _imageNames = [NSMutableArray array];
    }
    return _imageNames;
}


@end
