//
//  CPMyPublishFrameModel.h
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CPMyPublishModel;
#define ContentFont [UIFont systemFontOfSize:16]
@interface CPMyPublishFrameModel : NSObject

@property (nonatomic, strong) CPMyPublishModel *model;

/** 时间戳label的frame */
@property (nonatomic, assign) CGRect timeStampF;

/** 内容label的frame */
@property (nonatomic, assign) CGRect contentLableF;

/** 图片View的frame */
@property (nonatomic, assign) CGRect photosViewF;

/** 底部View的frame */
@property (nonatomic, assign) CGRect bottomViewF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
