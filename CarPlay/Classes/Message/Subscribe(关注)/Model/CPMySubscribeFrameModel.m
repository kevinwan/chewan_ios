//
//  CPMyPublishFrameModel.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMySubscribeFrameModel.h"
#import "CPMySubscribeModel.h"
#import "NSString+Extension.h"
#import "HMStatusPhotosView.h"

#define KIconBtnWH 50
#define KCellMargin 10
@implementation CPMySubscribeFrameModel

- (void)setModel:(CPMySubscribeModel *)model
{
    _model = model;

    CPOrganizer *organizer = model.organizer;
    CGFloat iconBtnX = KCellMargin;
    CGFloat iconBtnY = 15;
    CGFloat iconBtnW = KIconBtnWH;
    CGFloat iconBtnH = KIconBtnWH;
    self.iconBtnF = CGRectMake(iconBtnX, iconBtnY, iconBtnW,iconBtnH);
    _cellHeight = CGRectGetMaxY(_iconBtnF);
    
    CGFloat payBtnY = CGRectGetMaxY(_iconBtnF) + 8;
    CGFloat payBtnW = 40;
    CGFloat payBtnX = (iconBtnW - payBtnW) * 0.5 + KCellMargin;
    CGFloat payBtnH = 15;
    self.payViewF = CGRectMake(payBtnX, payBtnY, payBtnW, payBtnH);
    _cellHeight = CGRectGetMaxY(_payViewF);
    
    if (model.totalSeat && model.holdingSeat) {
        CGFloat seatViewW = iconBtnW;
        CGFloat seatViewH = [model.seatStr sizeWithFont:SeatViewFont].height;
        CGFloat seatViewX = iconBtnX;
        CGFloat seatViewY = CGRectGetMaxY(_payViewF) + 5;
        self.seatViewF = CGRectMake(seatViewX, seatViewY, seatViewW, seatViewH);
        _cellHeight = CGRectGetMaxY(_seatViewF);
    }
    
    CGFloat nameLableX = CGRectGetMaxX(_iconBtnF) + KCellMargin;
    CGFloat nameLableW = [organizer.nickname sizeWithFont:NickNameFont].width;
    CGFloat nameLableH = [organizer.nickname sizeWithFont:NickNameFont].height;
    CGFloat nameLableY = 22.5;
    self.nameLabelF = CGRectMake(nameLableX, nameLableY, nameLableW,nameLableH);
    
    
    CGFloat sexViewX = CGRectGetMaxX(_nameLabelF) + 3;
    CGFloat sexViewW = 30;
    CGFloat sexViewH = 15;
    CGFloat sexViewY = 23.5;
    self.sexViewF = CGRectMake(sexViewX, sexViewY, sexViewW,sexViewH);
    
    CGFloat timeLableY = sexViewY;
    CGFloat timeLableW = [model.publishTimeStr sizeWithFont:TimeLabelFont].width;
    CGFloat timeLableH = [model.publishTimeStr sizeWithFont:TimeLabelFont].height;
    CGFloat timeLableX = kScreenWidth - timeLableW - KCellMargin;
    self.timeLabelF = CGRectMake(timeLableX, timeLableY, timeLableW,timeLableH);
    
    
    CGFloat descLableX = 0;
    if (organizer.carBrandLogo.length > 0) {
        CGFloat brandX = nameLableX;
        CGFloat brandY = CGRectGetMaxY(_nameLabelF) + KCellMargin;
        CGFloat brandW = 15;
        CGFloat brandH = 15;
        self.brandF = CGRectMake(brandX, brandY, brandW, brandH);
        descLableX = CGRectGetMaxX(_brandF) + 5;
    }else{
        self.brandF = CGRectZero;
        descLableX = nameLableX;
    }
    
    CGFloat descLableY = CGRectGetMaxY(_nameLabelF) + KCellMargin;
    CGFloat descLableW = [organizer.descStr sizeWithFont:DescFont].width;
    CGFloat descLableH = [organizer.descStr sizeWithFont:DescFont].height;
    self.descLabelF = CGRectMake(descLableX, descLableY, descLableW,descLableH);
    
    CGFloat contentLbX = nameLableX;
    CGFloat contentLbY = CGRectGetMaxY(_iconBtnF) + 8;
    CGFloat maxW = kScreenWidth - nameLableX - KCellMargin;
    CGFloat contentLbW = [model.introduction sizeWithFont:NickNameFont maxW:maxW].width;
    CGFloat contentLbH = [model.introduction sizeWithFont:NickNameFont maxW:maxW].height;
    self.contentLableF = CGRectMake(contentLbX, contentLbY, contentLbW, contentLbH);
    
    _cellHeight = CGRectGetMaxY(_contentLableF);
    
    if (model.cover.count > 0) {
        CGSize phontosViewSize = [HMStatusPhotosView sizeWithPhotosCount:model.cover.count];
        
        CGFloat photoViewX = nameLableX;
        CGFloat photoViewY = _cellHeight + KCellMargin;
        CGFloat photoViewW = phontosViewSize.width;
        CGFloat photoViewH = phontosViewSize.height;
        self.photosViewF = CGRectMake(photoViewX, photoViewY, photoViewW, photoViewH);
        _cellHeight = CGRectGetMaxY(_photosViewF);
        
    }else{
        _cellHeight = CGRectGetMaxY(_contentLableF);
    }
    
    CGFloat bottomViewX = nameLableX;
    CGFloat bottomViewY = _cellHeight + 2;
    CGFloat bottomViewW = maxW;
    CGFloat bottomViewH = 65;
    self.bottomViewF = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    _cellHeight = CGRectGetMaxY(_bottomViewF) + KCellMargin;
}

@end
