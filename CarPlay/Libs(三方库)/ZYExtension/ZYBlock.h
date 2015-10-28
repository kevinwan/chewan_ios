//
//  ZYBlock.h
//  ZYFoundationTest
//
//  Created by zysu on 15/6/8.
//  Copyright (c) 2015年 suzhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZYVoidBlock)();

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
extern void ZYMainThead(dispatch_block_t block);

/**
 *  底层使用NSOperation
 */
extern void ZYMainOperation(ZYVoidBlock block);
extern void ZYAsyncOperation(ZYVoidBlock block);
