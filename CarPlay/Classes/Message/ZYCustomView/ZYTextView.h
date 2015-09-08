//
//  ZYTextView.h
//  CarPlay
//
//  Created by chewan on 15/9/8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYTextView : UITextView

/**
 *  占位文字
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  占位文字的颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
