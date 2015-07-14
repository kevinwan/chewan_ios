//
//  CPMyPublishFrameModel.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMySubscribeFrameModel.h"
#import "CPMySubscribeModel.h"

#define KIconBtnWH 50
@implementation CPMySubscribeFrameModel

- (void)setModel:(CPMySubscribeModel *)model
{
    _model = model;
    
    CGFloat iconBtnX = 10;
    CGFloat iconBtnY = 15;
    CGFloat iconBtnW = KIconBtnWH;
    CGFloat iconBtnH = KIconBtnWH;
    self.iconBtnF = CGRectMake(iconBtnX, iconBtnY, iconBtnW,iconBtnH);
    
    CGFloat nameLableX = 10;
    CGFloat nameLableY = 15;
    CGFloat nameLableW = KIconBtnWH;
    CGFloat nameLableH = KIconBtnWH;
    self.nameLabelF = CGRectMake(nameLableX, nameLableY, nameLableW,nameLableH);
    
    CGFloat timeLableX = 10;
    CGFloat timeLableY = 15;
    CGFloat timeLableW = KIconBtnWH;
    CGFloat timeLableH = KIconBtnWH;
    self.timeLabelF = CGRectMake(timeLableX, timeLableY, timeLableW,timeLableH);
    
    CGFloat descLableX = 10;
    CGFloat descLableY = 15;
    CGFloat descLableW = KIconBtnWH;
    CGFloat descLableH = KIconBtnWH;
    self.descLabelF = CGRectMake(descLableX, descLableY, descLableW,descLableH);
    
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
