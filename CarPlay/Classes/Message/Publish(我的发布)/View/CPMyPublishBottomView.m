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
    self.addressBtn = [self addBtnWithIcon:@"目的地"];
    self.moneyBtn = [self addBtnWithIcon:@"费用"];
    
    [topView addSubview:self.dateBtn];
    [topView addSubview:self.addressBtn];
    [topView addSubview:self.moneyBtn];
    
    // 添加底部区域
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [Tools getColor:@"f5f7fa"];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UILabel *personNumLable = [[UILabel alloc] init];
    personNumLable.textColor = [Tools getColor:@"656d78"];
    personNumLable.font = [UIFont systemFontOfSize:12];
    personNumLable.numberOfLines = 0;
    personNumLable.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:personNumLable];
    self.personNumLable = personNumLable;
    
    CPChatButton *chatBtn = [CPChatButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:chatBtn];
    self.chatBtn = chatBtn;
    
    CPMoreButton *moreBtn = [CPMoreButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:moreBtn];
    [moreBtn setTitle:@"···" forState:UIControlStateNormal];
    self.moreBtn = moreBtn;
    
    for (int i = 0; i < KPersonNum; i++) {
        CPIconButton *btn = [CPIconButton buttonWithType:UIButtonTypeCustom];
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
    if (kScreenWidth == 320) {
        btn.titleLabel.font = [UIFont systemFontOfSize:9];
    }else{
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    [btn setTitleColor:[Tools getColor:@"656d78"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算topview中的尺寸
    CGFloat topViewH = self.height * 0.4;
    self.topView.frame = CGRectMake(0, 0, self.height, topViewH);
    
    CGFloat btnW = self.width / 3.0;
    CGFloat btnH = topViewH;
    NSUInteger count = self.topView.subviews.count;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = self.topView.subviews[i];
        CGFloat btnX = i * btnW;
        if (i == 1) {
            btnX -= 8;
            btnW += 8;
        }
        CGFloat btnY = 0;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    // 计算底部View的尺寸
    [self layoutBottomView];
}

- (void)layoutBottomView
{
    
    CGFloat bottomViewH = self.height * 0.6;
    self.bottomView.frame = CGRectMake(0, self.height * 0.4, self.width, bottomViewH);
    
    self.personNumLable.frame = CGRectMake(5, 2, 50, bottomViewH - 4);
    
    self.chatBtn.x = self.width - self.chatBtn.width - 10;
    self.chatBtn.centerY = self.bottomView.centerYInSelf;
    
    CGFloat personBtnStartX = self.personNumLable.right + 10;
    CGFloat personBtnH = bottomViewH - 20;
    CGFloat personBtnY = (bottomViewH - personBtnH) * 0.5;
    CGFloat personBtnW = personBtnH;
    
    CGFloat maxX = 0;
    for (int i = 0; i < KPersonNum; i ++) {
        UIView *btn = [self.bottomView viewWithTag:i + 1];
        CGFloat btnX = personBtnStartX + i * (personBtnW + 5);
        btn.frame = CGRectMake(btnX, personBtnY, personBtnW, personBtnH);
        if (i == KPersonNum -1){
            maxX = CGRectGetMaxX(btn.frame);
        }
    }
    
    self.moreBtn.x = maxX + 5;
    self.moreBtn.y = personBtnY;
    self.moreBtn.width = personBtnW;
    self.moreBtn.height = personBtnH;
}

- (void)setModel:(CPMyPublishModel *)model
{
    _model = model;
    
    [self.dateBtn setTitle:model.startDate forState:UIControlStateNormal];
    [self.addressBtn setTitle:model.location forState:UIControlStateNormal];
    [self.moneyBtn setTitle:model.pay forState:UIControlStateNormal];
    
    // 显示人数红色的处理
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"参与人数"];
    NSString *personNumStr = [NSString stringWithFormat:@"%zd",model.members.count];
    NSAttributedString *personNumAttrStr = [[NSAttributedString alloc] initWithString:personNumStr attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"fc6e51"]}];
    [str appendAttributedString:personNumAttrStr];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"人"]];
    self.personNumLable.attributedText = str;
    
    // 循环利用的处理,必须遍历全部的IconButton
    NSUInteger count = model.members.count;
    for (int i = 0; i < KPersonNum; i++) {
        
        CPIconButton *btn = (CPIconButton *)[self.bottomView viewWithTag:i + 1];
        if (i < count) {
            btn.hidden = NO;
            CPOrganizer *org = model.members[i];
            [btn sd_setImageWithURL:[NSURL URLWithString:org.photo] forState:UIControlStateNormal placeholderImage:nil];
        }else{
            btn.hidden = YES;
        }
    }
    
    // 对moreBtn的处理
    if (count >= KPersonNum) {
        self.moreBtn.hidden = NO;
    }else{
        self.moreBtn.hidden = YES;
    }
}

@end
