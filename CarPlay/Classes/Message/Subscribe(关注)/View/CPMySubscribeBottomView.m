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
#import "CPIconButton.h"
#import "CPMoreButton.h"
#import "UIButton+WebCache.h"
#import "CPMySubscribeModel.h"

#define KPersonNum 4 // 参与人数View的个数
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

// 聊天的按钮
@property (nonatomic, strong) CPMoreButton *moreBtn;

@end

@implementation CPMySubscribeBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    // 初始化顶部区域
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    self.topView = topView;
    
    self.dateLable = [[UILabel alloc] init];
    self.dateLable.textColor = [Tools getColor:@"656d78"];
    self.dateLable.font = [UIFont systemFontOfSize:12];
    self.addressLable = [[UILabel alloc] init];
    self.addressLable.textColor = [Tools getColor:@"656d78"];
    self.addressLable.font = [UIFont systemFontOfSize:12];
    self.addressLable.textAlignment = NSTextAlignmentRight;
    [topView addSubview:self.dateLable];
    [topView addSubview:self.addressLable];
    
    // 添加底部区域
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [Tools getColor:@"f5f7fa"];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    CPChatButton *chatBtn = [CPChatButton buttonWithType:UIButtonTypeCustom];
    chatBtn.hidden = YES;
    [bottomView addSubview:chatBtn];
    self.chatBtn = chatBtn;
    
    
    CPMoreButton *moreBtn = [CPMoreButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    
    for (int i = 0; i < KPersonNum; i++) {
        CPIconButton *btn = [CPIconButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 1;
        [bottomView addSubview:btn];
    }

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
    
    self.chatBtn.x = self.width - self.chatBtn.width - 10;
    self.chatBtn.y = (bottomViewH - self.chatBtn.height) * 0.5;
    
    CGFloat personBtnStartX = 5;
    CGFloat personBtnH = bottomViewH - 16;
    CGFloat personBtnY = (bottomViewH - personBtnH) * 0.5;
    CGFloat personBtnW = personBtnH;
    
    count = self.bottomView.subviews.count;
    CGFloat maxX = 0;
    
    for (int i = 0; i < KPersonNum; i ++) {
       UIView *btn = [self.bottomView viewWithTag:i + 1];
        CGFloat btnX = personBtnStartX + i * (personBtnW + 5);
        btn.frame = CGRectMake(btnX, personBtnY, personBtnW, personBtnH);
        maxX = btnX + personBtnW;
    }
    
    self.moreBtn.width = personBtnW;
    self.moreBtn.height = personBtnH;
    self.moreBtn.x = maxX + 5;
    self.moreBtn.y = personBtnY;
    
}

- (void)setModel:(CPMySubscribeModel *)model
{
    _model = model;
    
    self.dateLable.text = [NSString stringWithFormat:@"时间: %@",model.startStr];
    
    self.addressLable.text = [NSString stringWithFormat:@"地点: %@",model.location];

    NSArray *members = model.members;
    
    NSUInteger count = members.count > 4 ? 4 : members.count;

    for (int i = 0; i < KPersonNum; i++) {
        UIView *view = [self.bottomView viewWithTag:i + 1];
        if (i < count) {
            view.hidden = NO;
        }else{
            view.hidden = YES;
        }
    }
    
    for (int i = 0; i < count; i++){
        UIButton *btn = (UIButton *)[self.bottomView viewWithTag:i + 1];
         CPOrganizer *organizer = model.members[i];
        
        [btn sd_setImageWithURL:[NSURL URLWithString:organizer.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    if (count == 4) {
        self.moreBtn.hidden = NO;
        [self.moreBtn setTitle:[NSString stringWithFormat:@"%zd",members.count] forState:UIControlStateNormal];
    }else{
        self.moreBtn.hidden = YES;
    }
    [self.chatBtn setTitle:@"我要去玩" forState:UIControlStateNormal];
}

@end
