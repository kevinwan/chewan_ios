//
//  HMDownloadIMGManager.m
//  01图片下载框架
//
//  Created by itheima on 15/10/27.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMDownloadIMGManager.h"
#import "HMDownloadIMGOperation.h"
#import "NSString+Path.h"

@interface HMDownloadIMGManager()

@property(nonatomic,strong) NSOperationQueue *queue;

//操作缓存
@property(nonatomic,strong) NSMutableDictionary *operationCache;

//内存缓存
@property(nonatomic,strong) NSMutableDictionary *imgCache;

@end

@implementation HMDownloadIMGManager
#pragma mark 懒加载
-(NSOperationQueue *)queue{
    if(!_queue){
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

-(NSMutableDictionary *)operationCache{
    if(!_operationCache){
        _operationCache = [NSMutableDictionary dictionary];
    }
    return _operationCache;
}

-(NSMutableDictionary *)imgCache{
    if(!_imgCache){
        _imgCache = [NSMutableDictionary dictionary];
    }
    return _imgCache;
}

- (void)clearCacheFromDisk
{
    
}

- (void)clearCacheFromMemery
{
    [self.imgCache removeAllObjects];
}

+(instancetype)shareInstance{
    static HMDownloadIMGManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance  = [[HMDownloadIMGManager alloc] init];
    });
    return instance;
}

-(void)downloadIMGWithAddr:(NSString *)addr finishBlock:(void (^)(UIImage *))finishBlock{
    //判断之前已经有操作，直接返回
    if(self.operationCache[addr]){
        NSLog(@"please wait %@ ",addr);
        return;
    }
    
    //判断图片已经存在
    UIImage *image = self.imgCache[addr];
    if(image){
        NSLog(@"men cache exist %@ ",addr);
        finishBlock(image);
        return;
    }else{
        //判断沙盒缓存
        UIImage *image = [UIImage imageWithContentsOfFile:[addr appendCachePath]];
        if(image){
            //沙盒存在
            NSLog(@"sandbox cache exist %@ ",addr);
            [self.imgCache setObject:image forKey:addr];
            finishBlock(image);
            return;
        }
    }
    
#pragma mark ---------下载代码 ---------
    
    HMDownloadIMGOperation *downloadIMGOperation = [HMDownloadIMGOperation operationWithAddr:addr finishBlock:^(UIImage *image) {
        
        //添加图片到内存缓存
        if (image) {
            
            [self.imgCache setObject:image forKey:addr];
            
            //删除操作
            [self.operationCache removeObjectForKey:addr];
            
            finishBlock(image);
        }
        
    }];
    
    //加入操作缓存
    [self.operationCache setObject:downloadIMGOperation forKey:addr];
    
    //操作加入队列
    [self.queue addOperation:downloadIMGOperation];
}

-(void)cancelDownloadWithAddr:(NSString *)addr{
    //取出之前的操作
    HMDownloadIMGOperation *op = self.operationCache[addr];
    if(op){
        //取消
        [op cancel];
    }
}
@end
