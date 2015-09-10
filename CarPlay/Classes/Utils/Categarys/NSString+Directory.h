//
//  NSString+Directory.h
//  CarPlay
//
//  Created by chewan on 15/9/10.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Directory)

/**
 *  拼接为文档的路径
 */
- (NSString *)documentPath;

/**
 *  拼接为缓存的路径
 */
- (NSString *)cachePath;

/**
 *  拼接为临时文件的路径
 */
- (NSString *)tempPath;

@end
