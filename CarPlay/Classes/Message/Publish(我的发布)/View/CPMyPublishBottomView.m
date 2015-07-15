//
//  CPMyPublishBottomView.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyPublishBottomView.h"
#import "CPMyPublishModel.h"
#import "UIView+Extension.h"
#import "CPChatButton.h"

#define KPersonNum 3 // 参与人数View的个数
@interface CPMyPublishBottomView()

// 顶部的view
@property (nonatomic, strong) UIView *topView;

// 显示日期的View
@property (nonatomic, strong) UIButton *dateBtn;

// 显示地址的按钮
@property (nonatomic, strong) UIButton *addressBtn;

// 显示谁请客的按钮
@property (nonatomic, strong) UIButton *moneyBtn;

// 底部的view
@property (nonatomic, strong) UIView *bottomView;

// 显示人数的View
@property (nonatomic, strong) UILabel *personNumLable;

// 聊天的按钮
@property (nonatomic, strong) CPChatButton *chatBtn;

@end

@implementation CPMyPublishBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 初始化顶部区域
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        self.topView = topView;
        
        self.dateBtn = [self addBtnWithIcon:nil titile:@"7月14号"];
        self.addressBtn = [self addBtnWithIcon:nil titile:@"万达影城CBD"];
        self.moneyBtn = [self addBtnWithIcon:nil titile:@"你请客"];
        
        [topView addSubview:self.dateBtn];
        [topView addSubview:self.addressBtn];
        [topView addSubview:self.moneyBtn];
        
        // 添加底部区域
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor grayColor];
        [self addSubview:bottomView];
        self.bottomView = bottomView;
        
        UILabel *personNumLable = [[UILabel alloc] init];
        [bottomView addSubview:personNumLable];
        self.personNumLable = personNumLable;
        
        CPChatButton *chatBtn = [CPChatButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:chatBtn];
        self.chatBtn = chatBtn;
        
        for (int i = 0; i < KPersonNum; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [bottomView addSubview:btn];
        }
        
    }
    return self;
}

- (UIButton *)addBtnWithIcon:(NSString *)icon titile:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算topview中的尺寸
    CGFloat topViewH = self.height * 0.4;
    self.topView.frame = CGRectMake(0, 0, self.height, topViewH);
    
    CGFloat btnW = self.width / 3;
    CGFloat btnH = topViewH;
    NSUInteger count = self.topView.subviews.count;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = self.topView.subviews[i];
        CGFloat btnX = i * btnW;
        CGFloat btnY = 0;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    // 计算底部View的尺寸
    CGFloat bottomViewH = self.height * 0.6;
    self.bottomView.frame = CGRectMake(0, topViewH, self.width, bottomViewH);
    
    self.personNumLable.frame = CGRectMake(2, 2, 30, bottomViewH - 6);
    
    self.chatBtn.width = 30;
    self.chatBtn.x = self.width - 30 - 10;
    self.chatBtn.height = 20;
    self.chatBtn.y = (bottomViewH - 20) * 0.5;
    
    CGFloat personBtnStartX = self.personNumLable.right + 10;
    CGFloat personBtnH = bottomViewH - 10;
    CGFloat personBtnY = (bottomViewH - personBtnH) * 0.5;
    CGFloat personBtnW = personBtnH;
    count = self.bottomView.subviews.count;
    for (int i = 0, j = 0; i < count; i ++) {
        UIButton *btn = self.topView.subviews[i];
        if ([btn isKindOfClass:[UIButton class]] && ![btn  isKindOfClass:[CPChatButton class]]) {
            
            CGFloat btnX = personBtnStartX + j * personBtnW;
            btn.frame = CGRectMake(btnX, personBtnY, personBtnW, personBtnH);
            j++;
        }
    }
}

- (void)setModel:(CPMyPublishModel *)model
{
    _model = model;
    
    
}

@end
