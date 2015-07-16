//
//  CPMyPublishFrameModel.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyPublishFrameModel.h"
#import "CPMyPublishModel.h"
#import "NSString+Extension.h"
#import "HMStatusPhotosView.h"
#define KMargin 10

@implementation CPMyPublishFrameModel

- (void)setModel:(CPMyPublishModel *)model
{
    _model = model;
    
    CGFloat timeStampLabelX = 10;
    CGFloat timeStampLabelY = 15;
    CGFloat timeStampLabelW = 40;
    CGFloat timeStampLabelH = 20;
    self.timeStampF = CGRectMake(timeStampLabelX, timeStampLabelY, timeStampLabelW, timeStampLabelH);
    _cellHeight = CGRectGetMaxY(_timeStampF);
    
    CGFloat contentLbX = CGRectGetMaxX(_timeStampF) + 25;
    CGFloat contentLbY = timeStampLabelY + 2;
    CGFloat maxW = kScreenWidth - contentLbX - KMargin;
    CGFloat contentLbW = [model.introduction sizeWithFont:ContentFont maxW:maxW].width;
    CGFloat contentLbH = [model.introduction sizeWithFont:ContentFont maxW:maxW].height;
    self.contentLableF = CGRectMake(contentLbX, contentLbY, contentLbW, contentLbH);
    _cellHeight = CGRectGetMaxY(_contentLableF);
    
    if (model.cover.count > 0) {
        
        CGFloat photoViewX = contentLbX;
        CGFloat photoViewY = _cellHeight + KMargin;
        CGFloat photoViewW = [HMStatusPhotosView sizeWithPhotosCount:model.cover.count].width;
        CGFloat photoViewH = [HMStatusPhotosView sizeWithPhotosCount:model.cover.count].height;;
        self.photosViewF = CGRectMake(photoViewX, photoViewY, photoViewW, photoViewH);
        _cellHeight = CGRectGetMaxY(_photosViewF);
    }else{
        self.photosViewF = CGRectZero;
    }
    
    CGFloat bottomViewX = contentLbX;
    CGFloat bottomViewY = _cellHeight + KMargin;
    CGFloat bottomViewW = kScreenWidth - contentLbX- KMargin;
    CGFloat bottomViewH = 70;
    self.bottomViewF = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    _cellHeight = CGRectGetMaxY(_bottomViewF) + KMargin;
}

@end
