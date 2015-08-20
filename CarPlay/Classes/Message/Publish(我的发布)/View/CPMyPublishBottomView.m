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
#import "CPTopViewButton.h"
#import "CPMoreButton.h"
#import "CPIconButton.h"
#import "UIButton+WebCache.h"
#import "CPMySubscribeModel.h"

#define KPersonNum 4 // 参与人数View的个数
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

// 显示更多的按钮
@property (nonatomic, strong)  CPMoreButton *moreBtn;

@end

@implementation CPMyPublishBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubViews];
    }
    return self;
}

/**
 *  建立子控件
 */
- (void)setUpSubViews
{
    // 初始化顶部区域
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    self.topView = topView;
    
    self.dateBtn = [self addBtnWithIcon:@"开始时间"];
    self.moneyBtn = [self addBtnWithIcon:@"费用"];
    self.addressBtn = [self addBtnWithIcon:@"目的地"];
    
    [topView addSubview:self.dateBtn];
    [topView addSubview:self.addressBtn];
    [topView addSubview:self.moneyBtn];
    
    // 添加底部区域
    UIImageView *bottomView = [[UIImageView alloc] init];
    bottomView.userInteractionEnabled = YES;
    bottomView.image = [UIImage imageNamed:@"头像列表背景"];
    [self addSubview:bottomView];
    self.bottomView = bottomView;

    
    CPChatButton *chatBtn = [CPChatButton buttonWithType:UIButtonTypeCustom];
    [chatBtn addTarget:self action:@selector(memberManage) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:chatBtn];
    self.chatBtn = chatBtn;
    
    CPMoreButton *moreBtn = [CPMoreButton buttonWithType:UIButtonTypeCustom];
    [moreBtn addTarget:self action:@selector(joinPersonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    
    for (int i = 0; i < KPersonNum; i++) {
        CPIconButton *btn = [CPIconButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(joinPersonClick) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        [bottomView addSubview:btn];
    }
}

/**
 *  创建同时显示icon和title的button
 */
- (UIButton *)addBtnWithIcon:(NSString *)icon
{
    CPTopViewButton *btn = [CPTopViewButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算topview中的尺寸
    CGFloat topViewH = self.height * 0.6;
    self.topView.frame = CGRectMake(0, 0, self.width, topViewH);
    
    CGFloat btnW = self.width * 0.5;
    CGFloat btnH = topViewH * 0.4;
    
    self.dateBtn.x = 0;
    self.dateBtn.y = 0;
    self.dateBtn.width = btnW;
    self.dateBtn.height = btnH;
    
    [self.moneyBtn sizeToFit];
    self.moneyBtn.x = self.topView.width - self.moneyBtn.width - 10;
    self.moneyBtn.centerY = self.dateBtn.centerYInSuper;
    
    self.addressBtn.x = 0;
    self.addressBtn.y = btnH +4;
    self.addressBtn.width = self.width;
    self.addressBtn.height = btnH;
    
    // 计算底部View的尺寸
    [self layoutBottomView];
}

- (void)layoutBottomView
{
    
    CGFloat bottomViewH = self.height * 0.5;

    self.bottomView.frame = CGRectMake(0, self.height * 0.4 + 14, self.width, bottomViewH);
    
    self.chatBtn.x = self.width - self.chatBtn.width - 10;
    self.chatBtn.centerY = self.bottomView.centerYInSelf;

    CGFloat personBtnStartX = 5;
    CGFloat personBtnH = bottomViewH - 14;
    CGFloat personBtnY = (bottomViewH - personBtnH) * 0.5;
    CGFloat personBtnW = personBtnH;
    
    for (int i = 0; i < KPersonNum; i ++) {
        UIView *btn = [self.bottomView viewWithTag:i + 1];
        CGFloat btnX = personBtnStartX + i * (personBtnW + 5);
        btn.frame = CGRectMake(btnX, personBtnY, personBtnW, personBtnH);
    }
    NSUInteger count = self.model.members.count > KPersonNum? KPersonNum : self.model.members.count;
    self.moreBtn.x = personBtnStartX + count * (personBtnW + 5);
    self.moreBtn.y = personBtnY;
    self.moreBtn.width = personBtnW;
    self.moreBtn.height = personBtnH;
}

- (void)setModel:(CPMyPublishModel *)model
{
    _model = model;
    
    [self.dateBtn setTitle:model.startDateStr forState:UIControlStateNormal];
    [self.addressBtn setTitle:model.location forState:UIControlStateNormal];
    [self.moneyBtn setTitle:model.pay forState:UIControlStateNormal];
    
    
    // 循环利用的处理,必须遍历全部的IconButton
    NSUInteger count = model.members.count;
    for (int i = 0; i < KPersonNum; i++) {
        
        CPIconButton *btn = (CPIconButton *)[self.bottomView viewWithTag:i + 1];
        if (i < count) {
            btn.hidden = NO;
            CPOrganizer *org = model.members[i];
            [btn sd_setImageWithURL:[NSURL URLWithString:org.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }else{
            btn.hidden = YES;
        }
    }
    [self.moreBtn setTitle:[NSString stringWithFormat:@"%zd",self.model.members.count] forState:UIControlStateNormal];
    
    if (self.model.isOver){
        self.chatBtn.userInteractionEnabled = NO;
        [self.chatBtn showGameOver];
    }else{
        self.chatBtn.userInteractionEnabled = YES;
        [self.chatBtn showManageMember];
    }
    
    [self setNeedsLayout];
}

/**
 *  点击了成员管理
 */
- (void)memberManage
{
    [CPNotificationCenter postNotificationName:MyPublishToPlayNotify object:nil userInfo:@{ MyPublishToPlayInfo : @(self.model.row)}];
}

- (void)joinPersonClick
{
    [CPNotificationCenter postNotificationName:MyJoinPersonNotify object:nil userInfo:@{MyJoinPersonNotify : @(self.model.row)}];
}

@end
