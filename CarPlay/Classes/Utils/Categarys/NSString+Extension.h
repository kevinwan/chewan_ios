//
//  NSString+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
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

- (NSString *)trimStr;
@end
