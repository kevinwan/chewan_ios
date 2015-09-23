//
//  NSTimer+ZY
//  ZY
//
//  Created by ZY on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "NSTimer+ZY.h"

@implementation NSTimer (ZY)

+ (void)timerBlockInvoke:(NSTimer *)timer
{
    void (^block)()= timer.userInfo;
    if (block) {
        block();
    }
}


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerBlockInvoke:) userInfo:[block copy] repeats:repeats];
}


@end
