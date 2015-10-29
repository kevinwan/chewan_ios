//
//  HMDownloadIMGOperation.h
//  01图片下载框架
//
//  Created by itheima on 15/10/27.
//  Copyright (c) 2015年 heima. All rights reserved.
//
typedef void (^dispatch_block_t)(void);
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HMDownloadIMGOperation : NSOperation

//下载地址
@property(nonatomic,copy)NSString *addr;

//回调
@property(nonatomic,copy) void(^finishBlock)(UIImage *image);


+(instancetype)operationWithAddr:(NSString *)addr finishBlock:(void(^)(UIImage *image))finishBlock;

@end
