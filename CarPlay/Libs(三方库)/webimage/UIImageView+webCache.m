//
//  UIImageView+webCache.m
//  01图片下载框架
//
//  Created by itheima on 15/10/27.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "UIImageView+webCache.h"
#import "HMDownloadIMGOperation.h"
#import "HMDownloadIMGManager.h"
#import <objc/runtime.h>
const void * webCacheKEY = "webCache";

@implementation UIImageView (webCache)

-(void)downloadIMGWithAddr:(NSString *)addr{
    //判断之前是否已经开启过下载操作
    //如果不一样，可能已经开了操作
    if([self.currentAddr isEqualToString:addr]){
        //    //取出之前的操作
        return;
        [[HMDownloadIMGManager shareInstance] cancelDownloadWithAddr:self.currentAddr];
    }
    
    self.currentAddr = addr;
    self.image = nil;
    [[HMDownloadIMGManager shareInstance] downloadIMGWithAddr:addr finishBlock:^(UIImage *image) {
        self.image = image;
    }];
}

-(NSString *)currentAddr{
    //参数1：要被关联的对象
    //参数2：关联的KEY
    return objc_getAssociatedObject(self, webCacheKEY);
}

-(void)setCurrentAddr:(NSString *)currentAddr{
    //参数1：要被关联的对象
    //参数2：关联的KEY
    //参数3：关联的值
    //参数3：关联策略(内存引用)
    objc_setAssociatedObject(self, webCacheKEY, currentAddr, OBJC_ASSOCIATION_COPY);
}

@end
