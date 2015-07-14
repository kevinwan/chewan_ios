//
//  CPMyPublishFrameModel.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyPublishFrameModel.h"
#import "CPMyPublishModel.h"

@implementation CPMyPublishFrameModel

- (void)setModel:(CPMyPublishModel *)model
{
    _model = model;
    
    CGFloat timeStampLabelX = 10;
    CGFloat timeStampLabelY = 15;
    CGFloat timeStampLabelW = 0;
    CGFloat timeStampLabelH = 0;
    self.timeStampF = CGRectMake(timeStampLabelX, timeStampLabelY, timeStampLabelW, timeStampLabelH);
    
    CGFloat contentLbX = 0;
    CGFloat contentLbY = 0;
    CGFloat contentLbW = 0;
    CGFloat contentLbH = 0;
    self.contentLableF = CGRectMake(contentLbX, contentLbY, contentLbW, contentLbH);
    
    CGFloat photoViewX = 0;
    CGFloat photoViewY = 0;
    CGFloat photoViewW = 0;
    CGFloat photoViewH = 0;
    self.photosViewF = CGRectMake(photoViewX, photoViewY, photoViewW, photoViewH);
    
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = 0;
    CGFloat bottomViewW = 0;
    CGFloat bottomViewH = 0;
    self.bottomViewF = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
}

@end
