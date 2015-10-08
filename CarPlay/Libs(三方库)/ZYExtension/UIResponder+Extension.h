//
//  UIResponder+Extension.h
//  TestAnimation
//
//  Created by chewan on 15/8/24.
//  Copyright (c) 2015年 chewan. All rights reserved.
//  主要用于同一控制器的传值

#import <UIKit/UIKit.h>

@interface UIResponder (Extension)

/**
 *  对所有的UI控件进行扩展,方便值的存储和传递
 */
@property (nonatomic, assign) id zyModel;

/**
 *  重写父视图的这个方法会收到子视图传递来的数据,可以通过定义不同的key来区分子控件
 *
 *  @param notifyName key 用来区分不同的子控件事件
 *  @param userInfo       传递来的数据
 */
- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo;

@end
