//
//  ZYTextView.m
//  CarPlay
//
//  Created by chewan on 15/9/8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYTextView.h"

@implementation ZYTextView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

/**
 *  进行初始化设置
 */
- (void)setUp
{
    self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
    self.placeholderColor = [UIColor grayColor];
}

- (void)textChange:(NSString *)text
{
    // 进行重绘
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (self.hasText) return;
    
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 0;
    CGFloat h = rect.size.height - 2 * y;
    [self.placeholder drawInRect:CGRectMake(x, y, w, h) withAttributes:@{NSForegroundColorAttributeName : self.placeholderColor, NSFontAttributeName: self.font}];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
