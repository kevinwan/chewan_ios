//
//  CPMyPublishFrameModel.h
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CPMySubscribeModel;
@interface CPMySubscribeFrameModel : NSObject

@property (nonatomic, strong) CPMySubscribeModel *model;

/** 头像的frame */
@property (nonatomic, assign) CGRect iconBtnF;

/** 名称label的frame */
@property (nonatomic, assign) CGRect nameLabelF;

/** 性别和年龄View的frame */
@property (nonatomic, assign) CGRect sexViewF;

/** 发布时间的frame */
@property (nonatomic, assign) CGRect timeLabelF;

/** 描述的frame */
@property (nonatomic, assign) CGRect descLabelF;

/** 内容label的frame */
@property (nonatomic, assign) CGRect contentLableF;

/** 图片View的frame */
@property (nonatomic, assign) CGRect photosViewF;

/** 底部View的frame */
@property (nonatomic, assign) CGRect bottomViewF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
