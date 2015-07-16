//
//  CPMyPublishCell.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyPublishCell.h"
#import "CPMyPublishBottomView.h"
#import "CPMyPublishModel.h"
#import "CPMyPublishFrameModel.h"
#import "HMStatusPhotosView.h"
#import "UIView+Extension.h"
#import "HMStatusPhotosView.h"
#import "CPMySubscribeModel.h"

@interface CPMyPublishCell()

// 时间label
@property (nonatomic, strong) UILabel *timeStampLabel;

// 时间线
@property (nonatomic, strong) UIView *timeLine;

// 内容label
@property (nonatomic, strong) UILabel *contentLb;

// photoView
@property (nonatomic, strong) HMStatusPhotosView *photosView;

// cycleView
@property (nonatomic, strong) UIView *cycleView;

// 底部的View
@property (nonatomic, strong) CPMyPublishBottomView *bottomView;

@end

@implementation CPMyPublishCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"publishCell";
    CPMyPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CPMyPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UILabel *timeStampLabel = [[UILabel alloc] init];
    timeStampLabel.font = [UIFont systemFontOfSize:15];
    timeStampLabel.textAlignment = NSTextAlignmentCenter;
    timeStampLabel.textColor = [Tools getColor:@"48d1d5"];
    [self.contentView addSubview:timeStampLabel];
    self.timeStampLabel = timeStampLabel;
    
    UIView *timeLine = [[UIView alloc] init];
    timeLine.backgroundColor = CPColor(200, 200, 200, 0.5);
    [self.contentView addSubview:timeLine];
    self.timeLine = timeLine;
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.font = ContentFont;
    contentLb.textColor = [Tools getColor:@"434a53"];
    contentLb.numberOfLines = 0;
    [self.contentView addSubview:contentLb];
    self.contentLb = contentLb;
    
    UIView *cicleView = [[UIView alloc] init];
    cicleView.backgroundColor = [Tools getColor:@"48d1d5"];
    cicleView.layer.cornerRadius = 3;
    cicleView.clipsToBounds = YES;
    [self.contentView addSubview:cicleView];
    self.cycleView = cicleView;
    
    HMStatusPhotosView *photosView = [[HMStatusPhotosView alloc] init];
    [self.contentView addSubview:photosView];
    self.photosView = photosView;
    
    CPMyPublishBottomView *bottomView = [[CPMyPublishBottomView alloc] init];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)setFrameModel:(CPMyPublishFrameModel *)frameModel
{
    _frameModel = frameModel;
    
    CPMyPublishModel *model = frameModel.model;
    
    // 进行内容的设置
    self.timeStampLabel.text = model.publishTimeStr;
    self.contentLb.text = model.introduction;
    self.photosView.pic_urls = model.cover;
    self.bottomView.model = model;
    
    // 进行frame的设置
    self.timeStampLabel.frame = frameModel.timeStampF;
    
    self.contentLb.frame = frameModel.contentLableF;
    
    self.photosView.frame = frameModel.photosViewF;
    
    self.bottomView.frame = frameModel.bottomViewF;
    
    CGFloat timeLineY = 0;
    CGFloat timeCenterY = self.timeStampLabel.centerYInSuper;
    if (self.indexPath.row == 0) {
        timeLineY = timeCenterY;
    }
    self.timeLine.x = self.timeStampLabel.right + 5;
    self.timeLine.width = 1;
    self.timeLine.height = frameModel.cellHeight - timeLineY;
    self.timeLine.y = timeLineY;
    
    self.cycleView.width = 6;
    self.cycleView.height = 6;
    self.cycleView.centerX = self.timeLine.centerXInSuper;
    self.cycleView.centerY = self.timeStampLabel.centerYInSuper;
    
}

@end
