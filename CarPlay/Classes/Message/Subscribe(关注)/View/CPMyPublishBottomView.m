//
//  CPMyPublishBottomView.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMySubscribeBottomView.h"
#import "CPMySubscribeModel.h"
#import "UIView+Extension.h"
#import "CPChatButton.h"

#define KPersonNum 3 // 参与人数View的个数
@interface CPMySubscribeBottomView()

// 顶部的view
@property (nonatomic, strong) UIView *topView;

// 显示日期的View
@property (nonatomic, strong) UILabel *dateLable;

// 显示地址的按钮
@property (nonatomic, strong) UILabel *addressLable;

// 底部的view
@property (nonatomic, strong) UIView *bottomView;

// 聊天的按钮
@property (nonatomic, strong) CPChatButton *chatBtn;

@end

@implementation CPMySubscribeBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 初始化顶部区域
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        self.topView = topView;
        
        self.dateLable = [[UILabel alloc] init];
        self.addressLable = [[UILabel alloc] init];
        
        [topView addSubview:self.dateLable];
        [topView addSubview:self.addressLable];
        
        // 添加底部区域
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor grayColor];
        [self addSubview:bottomView];
        self.bottomView = bottomView;
        
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算topview中的尺寸
    CGFloat topViewH = self.height * 0.3;
    self.topView.frame = CGRectMake(0, 0, self.height, topViewH);
    
    CGFloat labW = self.width * 0.5;
    CGFloat labH = topViewH;
    NSInteger count = self.topView.subviews.count;
    for (int i = 0; i < count; i ++) {
        UILabel *btn = self.topView.subviews[i];
        CGFloat labX = i * labW;
        CGFloat labY = 0;
        btn.frame = CGRectMake(labX, labY, labW, labH);
    }
    
    // 计算底部View的尺寸
    CGFloat bottomViewH = self.height * 0.7;
    self.bottomView.frame = CGRectMake(0, topViewH, self.width, bottomViewH);
    
    self.chatBtn.width = 30;
    self.chatBtn.x = self.width - 30 - 10;
    self.chatBtn.height = 20;
    self.chatBtn.y = (bottomViewH - 20) * 0.5;
    
    
    CGFloat personBtnStartX = 5;
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

- (void)setModel:(CPMySubscribeModel *)model
{
    _model = model;
    
    
}

@end
