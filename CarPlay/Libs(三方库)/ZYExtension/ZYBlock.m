//
//  ZYBlock.m
//  ZYFoundationTest
//
//  Created by zysu on 15/6/8.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "ZYBlock.h"

void ZYAsyncThead(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(0, 0),block);    
}

void ZYMainThead(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void ZYMainOperation(ZYVoidBlock block)
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:block];
}

void ZYAsyncOperation(ZYVoidBlock block)
{
    [[[NSOperationQueue alloc] init] addOperationWithBlock:block];
}

void ZYAnimaiton(NSTimeInterval time, ZYVoidBlock block)
{
    [UIView animateWithDuration:time animations:block];
}

void ZYAfter(NSTimeInterval time,ZYVoidBlock block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
