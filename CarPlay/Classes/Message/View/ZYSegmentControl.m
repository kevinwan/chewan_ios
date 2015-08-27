//
//  ZYSegmentControl.m
//  CarPlay
//
//  Created by chewan on 15/8/5.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYSegmentControl.h"
#import "ZYSegment.h"

@interface ZYSegmentControl ()
@property (nonatomic, strong) UIView *divider1;
@property (nonatomic, strong) UIView *divider2;
@property (nonatomic, weak) ZYSegment *lastSeg;
@end

@implementation ZYSegmentControl

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
    
    self.layer.cornerRadius = 2;
    self.layer.borderColor = [Tools getColor:@"e6e9ed"].CGColor;
    self.layer.borderWidth = 0.5;
    self.clipsToBounds = YES;
}

- (ZYSegment *)addBtnWithTitle:(NSString *)title
{
    ZYSegment *button = [[ZYSegment alloc] init];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    return button;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    for (int i = 0; i < items.count; i++) {
        ZYSegment *button = [self addBtnWithTitle:items[i]];
        if (i == items.count - 1) {
            [self buttnClick:button];
        }
        button.tag = 20 + i;
    }
    
    UIView *divider1 = [[UIView alloc] init];
    divider1.backgroundColor = [Tools getColor:@"e6e9ed"];
    [self addSubview:divider1];
    self.divider1 = divider1;
    
    UIView *divider2 = [[UIView alloc] init];
    divider2.backgroundColor = [Tools getColor:@"e6e9ed"];
    [self addSubview:divider2];
    self.divider2 = divider2;
    [self setNeedsLayout];
}

- (void)buttnClick:(ZYSegment *)segment
{
    if (self.lastSeg == segment) {
        return;
    }
    
    self.lastSeg.selected = NO;
    segment.selected = !segment.isSelected;
    self.lastSeg = segment;
    
    if (segment.tag == 20) {
        self.divider1.hidden = YES;
        self.divider2.hidden = NO;
    }else if (segment.tag == 21){
        self.divider1.hidden = YES;
        self.divider2.hidden = YES;
    }else{
        self.divider1.hidden = NO;
        self.divider2.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = (self.width - 1) / 3;
    CGFloat btnH = self.height;
    CGFloat btnX = 0;
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[ZYSegment class]]) {
            view.width = btnW;
            view.height = btnH - 0.5;
            view.x = btnX + 0.25;
            view.y = 0.25;
            btnX += btnW + 0.25;
        }
    }
    btnW = self.width / 3;
    self.divider1.x = btnW - 0.25;
    self.divider1.y = 0;
    self.divider1.height = btnH;
    self.divider1.width = 0.5;
    
    self.divider2.x = btnW + btnW - 0.25;
    self.divider2.y = 0;
    self.divider2.height = btnH;
    self.divider2.width = 0.5;
    
}

- (NSUInteger)selectedSegmentIndex
{
    return self.lastSeg.tag - 20;
}

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex
{
    [self buttnClick:(ZYSegment *)[self viewWithTag:selectedSegmentIndex + 20]];
}

@end
