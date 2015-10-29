//
//  UIImageView+webCache.h
//  01图片下载框架
//
//  Created by itheima on 15/10/27.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (webCache)

//之前下载的图片地址
//分类中属性没有生成getter setter 不能手动指定对应的成员变量
@property(nonatomic,copy) NSString *currentAddr;

-(void)downloadIMGWithAddr:(NSString *)addr;

@end
