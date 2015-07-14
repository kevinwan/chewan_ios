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
#import "HWPhotosView.h"
#import "UIView+Extension.h"

@interface CPMyPublishCell()

// 时间label
@property (nonatomic, strong) UILabel *timeStampLabel;

// 时间线
@property (nonatomic, strong) UIView *timeLine;

// 内容label
@property (nonatomic, strong) UILabel *contentLb;

// photoView
@property (nonatomic, strong) HWPhotosView *photosView;

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
    [self.contentView addSubview:timeStampLabel];
    self.timeStampLabel = timeStampLabel;
    
    UIView *timeLine = [[UIView alloc] init];
    timeLine.backgroundColor = [UIColor grayColor];
    self.timeLine = timeLine;
    
    UILabel *contentLb = [[UILabel alloc] init];
    [self.contentView addSubview:contentLb];
    self.contentLb = contentLb;
    
    HWPhotosView *photosView = [[HWPhotosView alloc] init];
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
    
    // 进行frame的设置
    self.timeStampLabel.frame = frameModel.timeStampF;
    
    self.contentLb.frame = frameModel.contentLableF;
    
    self.photosView.frame = frameModel.photosViewF;
    
    self.bottomView.frame = frameModel.bottomViewF;
    
    CGFloat timeLineY = 0;
    if (self.indexPath.row == 0) {
        timeLineY = 10;
    }
    self.timeLine.frame = CGRectMake(self.timeStampLabel.right , timeLineY, 1 , frameModel.cellHeight);
    
}
- (void)drawRect:(CGRect)rect
{
    // 1. 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2. 画圆
    // x 圆心的x
    // y 圆心的y
    // radius 半径
    // startAngle 开始角度
    // endAngle 结束角度
    // clockwise 0 顺时针 1 逆时针
    CGFloat x = 30;
    CGFloat y = 20;
    CGFloat radius = 0;
    CGContextAddArc(ctx, x, y, radius, 0, M_PI * 2, 0);
    // 3.设置颜色
    [[UIColor redColor] set];
    // 3.渲染
    //    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
}

@end
