//
//  CPNewMsgModel.m
//  CarPlay
//
//  Created by chewan on 15/7/29.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNewMsgModel.h"

@implementation CPNewMsgModel

- (void)setGender:(NSString *)gender
{
    _gender = [gender copy];
    self.isMan = [gender isEqualToString:@"男"] ? YES : NO;
}

@end
