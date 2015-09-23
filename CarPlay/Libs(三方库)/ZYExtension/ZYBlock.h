//
//  ZYBlock.h
//  ZYFoundationTest
//
//  Created by zysu on 15/6/8.
//  Copyright (c) 2015年 suzhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  简化的异步线程
 *
 *  @param block 需要在此线程执行的操作
 */
extern void ZYAsyncThead(dispatch_block_t block);

/**
 *  简化的主线程
 *
 *  @param block 需要在此线程执行的操作
 */
extern void ZYMainThread(dispatch_block_t block);
