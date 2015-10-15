//
//  ZYProgressView.h
//  CarPlay
//
//  Created by chewan on 10/14/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYProgressView : NSObject

/**
 *  显示一个仿安卓的提示信息
 *
 *  @param message 需要显示的信息
 */
+ (void)showMessage:(NSString *)message;

/**
 *  显示提示信息到指定的view上
 *
 *  @param message 需要显示的信息
 *  @param view    需要显示在那个view上
 */
+ (void)showMessage:(NSString *)message inView:(UIView *)view;
@end
