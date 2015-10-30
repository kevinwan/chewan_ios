//
//  CPUserTool.m
//  CarPlay
//
//  Created by chewan on 10/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPUserTool.h"

@implementation CPUserTool

+ (instancetype)sharedInstance
{
    static CPUserTool *_userTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userTool = [[CPUserTool alloc] init];
        if (CPIsLogin) {
            NSString *path=[[NSString alloc]initWithFormat:@"%@.info",[Tools getUserId]];
            CPUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            _userTool.user = user;
        }
    });
    return _userTool;
}

@end
