//
//  UIBarButtonItem+Extension.h
//  CarPlay
//
//  Created by 公平价 on 15/6/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickAction)();

@interface UIBarButtonItem (Extension)

/**
 *  快速创建barButtonItem
 *
 *  @param norimage    普通图片
 *  @param higImage    高亮图片
 *  @param title       文字
 *  @param clickAction 点击事件
 *
 *  @return item
 */
+ (instancetype)itemWithNorImage:(NSString *)norimage higImage:(NSString *)higImage title:(NSString *)title action:(ClickAction)clickAction;
/**
 *  快速创建barButtonItem
 *
 *  @param norimage    普通图片
 *  @param higImage    高亮图片
 *  @param title       文字
 *  @param action      点击事件
 *  @param target      响应者
 *  @return item
 */
+ (instancetype)itemWithNorImage:(NSString *)norimage higImage:(NSString *)higImage title:(NSString *)title target:(id)target action:(SEL)action;

@end
