//
//  UIBarButtonItem+Extension.m
//  CarPlay
//
//  Created by 公平价 on 15/6/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import <objc/runtime.h>

static const char ZYActionKey = '\0';

@interface UIBarButtonItem()
@property (nonatomic, copy) ClickAction clickAction;
@end

@implementation UIBarButtonItem (Extension)

- (void)setClickAction:(ClickAction)clickAction
{
    objc_setAssociatedObject(self, &ZYActionKey, clickAction, OBJC_ASSOCIATION_COPY);
}

- (ClickAction)clickAction
{
    return objc_getAssociatedObject(self, &ZYActionKey);
}

/**
 *  创建item
 *
 *  @param norimage 默认状态的图片
 *  @param higImage 高亮状态的图片
 *  @param title    标题
 *
 *  @return item
 */
+ (instancetype)itemWithNorImage:(NSString *)norimage higImage:(NSString *)higImage title:(NSString *)title action:(ClickAction)clickAction
{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    // 2.设置按钮的默认图片和高亮图片
    if (norimage != nil &&
        ![norimage isEqualToString:@""]) {
        
        [btn setImage:[UIImage imageNamed:norimage] forState:UIControlStateNormal];
    }
    if (higImage != nil &&
        ![higImage isEqualToString:@""]) {
        
        [btn setImage:[UIImage imageNamed:higImage] forState:UIControlStateHighlighted];
    }
    // 设置标题
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    
    // 4.设置按钮的frame
    // 可以调用控件的sizeToFit方法来自动调整控件的大小
    [btn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    // 3.监听按钮的点击事件
    [btn addTarget:item action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    item.clickAction = clickAction;
    // 5.根据按钮创建BarButtonItem
    return item;
}

- (void)click
{
    !self.clickAction?:self.clickAction();
}

/**
 *  创建item
 *
 *  @param norimage 默认状态的图片
 *  @param higImage 高亮状态的图片
 *  @param title    标题
 *
 *  @return item
 */
- (UIBarButtonItem *)initWithNorImage:(NSString *)norimage higImage:(NSString *)higImage title:(NSString *)title target:(id)target action:(SEL)action
{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    // 2.设置按钮的默认图片和高亮图片
    if (norimage != nil &&
        ![norimage isEqualToString:@""]) {
        
        [btn setImage:[UIImage imageNamed:norimage] forState:UIControlStateNormal];
    }
    if (higImage != nil &&
        ![higImage isEqualToString:@""]) {
        
        [btn setImage:[UIImage imageNamed:higImage] forState:UIControlStateHighlighted];
    }
    // 设置标题
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    // 3.监听按钮的点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 4.设置按钮的frame
    // 可以调用控件的sizeToFit方法来自动调整控件的大小
    [btn sizeToFit];
    
    // 5.根据按钮创建BarButtonItem
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (instancetype)itemWithNorImage:(NSString *)norimage higImage:(NSString *)higImage title:(NSString *)title target:(id)target action:(SEL)action
{
    return [[self alloc] initWithNorImage:norimage higImage:higImage title:title target:target action:action];
}

@end
