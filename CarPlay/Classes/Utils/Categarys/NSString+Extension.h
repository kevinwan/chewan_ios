//
//  NSString+Extension.h
//
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 苏兆云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  根据字号计算文字大小
 *
 *  @param font font
 *  @param maxW 限制宽度
 *
 *  @return size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  根据字号计算文字大小(一行)
 *
 *  @param font font
 *
 *  @return size
 */
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 *  计算当前文件\文件夹的内容大小
 */
- (NSInteger)fileSize;

/**
 *  去除空格后的字符串
 *
 *  @return
 */
- (NSString *)trim;

/**
 *  去除首位空格之后的length
 *
 *  @return length
 */
- (NSUInteger)trimLength;

/**
 *  判断是否包含某个字符串
 *  @return 是否包含
 */
- (BOOL)contains:(NSString *)string;

@end
