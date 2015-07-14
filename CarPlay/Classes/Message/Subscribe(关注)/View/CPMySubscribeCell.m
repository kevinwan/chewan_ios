//
//  CPMyPublishCell.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMySubscribeCell.h"
#import "CPMySubscribeBottomView.h"
#import "CPMySubscribeModel.h"
#import "CPMySubscribeFrameModel.h"
#import "HWPhotosView.h"
#import "CPChatButton.h"
#import "CPSexView.h"
#import "CPIconButton.h"

@interface CPMySubscribeCell()

/** 头像*/
@property (nonatomic, strong) CPIconButton *iconBtn;

/** 名称label */
@property (nonatomic, strong) UILabel *nameLabel;

/** 性别和年龄View */
@property (nonatomic, strong) CPSexView *sexView;

/** 发布时间 */
@property (nonatomic, strong) UILabel *timeLabel;

/** 描述的label */
@property (nonatomic, strong) UILabel *descLabel;

/** 内容label */
@property (nonatomic, strong) UILabel *contentLable;

/** 图片View */
@property (nonatomic, strong) HWPhotosView *photosView;

/** 底部View的frame */
@property (nonatomic, strong) CPMySubscribeBottomView *bottomView;

@end

@implementation CPMySubscribeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"publishCell";
    CPMySubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CPMySubscribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 进行cell的初始化操作
        [self setUpCell];
    }
    return self;
}

/**
 *  初始化操作
 */
- (void)setUpCell
{
    CPIconButton *iconBtn = [CPIconButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:iconBtn];
    self.iconBtn = iconBtn;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    CPSexView *sexView = [[CPSexView alloc] init];
    [self.contentView addSubview:sexView];
    self.sexView = sexView;
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.numberOfLines = 0;
    [self.contentView addSubview:contentLb];
    self.contentLable = contentLb;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *descLabel = [[UILabel alloc] init];
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    
    HWPhotosView *photosView = [[HWPhotosView alloc] init];
    [self.contentView addSubview:photosView];
    self.photosView = photosView;
    
    CPMySubscribeBottomView *bottomView = [[CPMySubscribeBottomView alloc] init];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)setFrameModel:(CPMySubscribeFrameModel *)frameModel
{
    _frameModel = frameModel;
    
    CPMySubscribeModel *model = frameModel.model;
    
    // 进行内容的设置
    
    // 进行frame的设置
    self.nameLabel.frame = frameModel.nameLabelF;
    
    self.iconBtn.frame = frameModel.iconBtnF;
    
    self.timeLabel.frame = frameModel.timeLabelF;
    
    self.descLabel.frame = frameModel.descLabelF;
    
    self.contentLable.frame = frameModel.contentLableF;
    
    self.photosView.frame = frameModel.photosViewF;
    
    self.bottomView.frame = frameModel.bottomViewF;
}

@end
