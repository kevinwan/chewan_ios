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
#import "CPChatButton.h"
#import "CPSexView.h"
#import "CPIconButton.h"
#import "UIButton+WebCache.h"
#import "HMStatusPhotosView.h"
#import "UIImageView+WebCache.h"
#import "CPPayButton.h"

@interface CPMySubscribeCell()

/** 头像*/
@property (nonatomic, strong) CPIconButton *iconBtn;

/** 名称label */
@property (nonatomic, strong) UILabel *nameLabel;

/** 性别和年龄View */
@property (nonatomic, strong) CPSexView *sexView;

/** 发布时间 */
@property (nonatomic, strong) UILabel *timeLabel;

/** 发布时间 */
@property (nonatomic, strong) UIImageView *carBrandLogo;

/** 发布时间 */
@property (nonatomic, strong) UIImageView *timeLogo;

/** 描述的label */
@property (nonatomic, strong) UILabel *descLabel;

/** payview */
@property (nonatomic, strong) CPPayButton *payView;

/** seatView */
@property (nonatomic, strong) UILabel *seatView;

/** 内容label */
@property (nonatomic, strong) UILabel *contentLable;

/** 图片View */
@property (nonatomic, strong) HMStatusPhotosView *photosView;

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
    nameLabel.font = NickNameFont;
    nameLabel.textColor = [Tools getColor:@"5d9beb"];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    CPSexView *sexView = [[CPSexView alloc] init];
    [self.contentView addSubview:sexView];
    self.sexView = sexView;
    
    UILabel *contentLb = [[UILabel alloc] init];
    contentLb.textColor = [Tools getColor:@"434a53"];
    contentLb.font = NickNameFont;
    contentLb.numberOfLines = 0;
    [self.contentView addSubview:contentLb];
    self.contentLable = contentLb;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = TimeLabelFont;
    timeLabel.textColor = [Tools getColor:@"aab2db"];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIImageView *carBrandLogo = [[UIImageView alloc] init];
    [self.contentView addSubview:carBrandLogo];
    self.carBrandLogo = carBrandLogo;
    
    UIImageView *timeLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"时间"]];
    [self.contentView addSubview:timeLogo];
    self.timeLogo = timeLogo;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textColor = [Tools getColor:@"aab2db"];
    descLabel.font = DescFont;
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    
    CPPayButton *payView = [CPPayButton buttonWithType:UIButtonTypeCustom];
    payView.titleLabel.font = PayViewFont;
    [self.contentView addSubview:payView];
    self.payView = payView;
    
    UILabel *seatView = [[UILabel alloc] init];
    seatView.textAlignment = NSTextAlignmentCenter;
    seatView.font = SeatViewFont;
    [self.contentView addSubview:seatView];
    self.seatView = seatView;
    
    HMStatusPhotosView *photosView = [[HMStatusPhotosView alloc] init];
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
    CPOrganizer *organizer = model.organizer;
    // 进行内容的设置
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:organizer.photo] forState:UIControlStateNormal placeholderImage:nil];
    self.nameLabel.text = organizer.nickname;
    [self.sexView setTitle:[NSString stringWithFormat:@"%zd",organizer.age] forState:UIControlStateNormal];
    self.sexView.isMan = organizer.isMan;
    self.timeLabel.text = model.publishTimeStr;
    
    if (organizer.carBrandLogo.length > 0) {
        self.carBrandLogo.hidden = NO;
        [self.carBrandLogo sd_setImageWithURL:[NSURL URLWithString:organizer.carBrandLogo]];
        self.descLabel.text = organizer.descStr;
    }else{
        self.carBrandLogo.hidden = YES;
        self.descLabel.text = @"带我飞 ~";
    }
    self.payView.payOption = model.pay;
    
    // 构造
    if (model.totalSeat > 0) {
        self.seatView.hidden = NO;
        self.seatView.attributedText = [self seatViewTextWithModel:model];
    }else{
        self.seatView.hidden = YES;
    }
    self.contentLable.text = model.introduction;
    self.photosView.pic_urls = model.cover;
    self.bottomView.model = model;
    
    // 进行frame的设置
    self.nameLabel.frame = frameModel.nameLabelF;
    
    self.sexView.frame = frameModel.sexViewF;
    
    self.iconBtn.frame = frameModel.iconBtnF;
    
    self.timeLabel.frame = frameModel.timeLabelF;
    
    self.timeLogo.x = CGRectGetMinX(frameModel.timeLabelF) - self.timeLogo.size.width - 3;
    self.timeLogo.centerY = CGRectGetMidY(frameModel.timeLabelF);
    
    self.carBrandLogo.frame = frameModel.brandF;
    
    self.descLabel.frame = frameModel.descLabelF;
    
    self.payView.frame = frameModel.payViewF;
    
    self.sexView.frame = frameModel.sexViewF;
    
    self.seatView.frame = frameModel.seatViewF;
    
    self.contentLable.frame = frameModel.contentLableF;
    
    self.photosView.frame = frameModel.photosViewF;
    
    self.bottomView.frame = frameModel.bottomViewF;
}

- (NSAttributedString *)seatViewTextWithModel:(CPMySubscribeModel *)model
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd",model.holdingSeat]];
    [str addAttribute:NSForegroundColorAttributeName value:[Tools getColor:@"fc6e51"] range:NSMakeRange(0, str.length)];
    NSMutableAttributedString *totalSeat = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%zd座",model.totalSeat] attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"aab2bd"]}];
    [str appendAttributedString:totalSeat];
    return str;
    
}

@end
