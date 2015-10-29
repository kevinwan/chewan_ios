//
//  HMDownloadIMGManager.h
//  01图片下载框架
//
//  Created by itheima on 15/10/27.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//目的：统一管理下载和取消下载
@interface HMDownloadIMGManager : NSObject

//单例
+(instancetype)shareInstance;

- (void)clearCacheFromDisk;
- (void)clearCacheFromMemery;

//下载
-(void)downloadIMGWithAddr:(NSString *)addr finishBlock:(void(^)(UIImage *image))finishBlock;

//取消下载
-(void)cancelDownloadWithAddr:(NSString *)addr;
@end
