//
//  NSTimer+ZY
//  ZY
//
//  Created by ZY on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSTimer (ZY)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;

@end
