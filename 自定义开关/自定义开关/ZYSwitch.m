//
//  ZYSwitch.m
//  自定义开关
//
//  Created by chewan on 9/28/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "ZYSwitch.h"
#import "UIView+Extension.h"

@interface ZYSwitch ()
@property (nonatomic, weak)  UIView *sliderView;
@end

@implementation ZYSwitch

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
    CGRect rect;
    rect.size = CGSizeMake(100, 30);
    self.frame = rect;
    self.backgroundColor = [UIColor lightGrayColor];
    // 可以滑动的View
    UIView *sliderView = [UIView new];
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    sliderView.backgroundColor = [UIColor whiteColor];
    sliderView.layer.borderColor = [UIColor blackColor].CGColor;
    [sliderView addGestureRecognizer:panG];
    sliderView.layer.borderWidth = 1;
    [self addSubview:sliderView];
    self.sliderView = sliderView;
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tapG];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    CGPoint p = [pan translationInView:self.sliderView];
    
    _sliderView.width += p.x;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan | UIGestureRecognizerStateChanged:
        {
            
            _sliderView.width += p.x;
//            if (_sliderView.x < 0) {
//                _sliderView.x = 0;
//            }else if (_sliderView.x > self.middleX){
//                _sliderView.x = self.middleX;
//            }
            
            break;
        }
        case UIGestureRecognizerStateEnded | UIGestureRecognizerStateCancelled:
        {
            if (_sliderView.x > self.width * 0.7 && !self.isOn) {
                self.on = YES;
            }else if (_sliderView.x < self.width * 0.3 && self.isOn){
                self.on = NO;
            }
        }
        default:
            break;
    }
//    
//    [pan setTranslation:CGPointZero inView:self.sliderView];
}

- (void)setOn:(BOOL)on
{
    _on = on;
    if (on) {
        
        self.backgroundColor = [UIColor greenColor];

        [UIView animateWithDuration:0.25 animations:^{
            self.sliderView.frame = CGRectMake(self.bounds.size.width * 0.5, 0, self.bounds.size.width * 0.5, self.bounds.size.height);
        }];
    }else{
                self.backgroundColor = [UIColor lightGrayColor];
        [UIView animateWithDuration:0.25 animations:^{
                  self.sliderView.frame = CGRectMake(0, 0, self.bounds.size.width * 0.5, self.bounds.size.height);
        }];
    }
}

- (void)tap
{
    self.on = !self.on;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.bounds.size.width * 0.5;
    CGFloat height = self.bounds.size.height;
    self.sliderView.frame = CGRectMake(x, y, width, height);
}

@end
