/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 50
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    self.backgroundColor = [UIColor blackColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    //test
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, .5)];
    bgview.backgroundColor = [UIColor grayColor];
    bgview.alpha = .5;
    [self addSubview:bgview];
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
    UILabel *phtotL = [[UILabel alloc]initWithFrame:CGRectMake(insets, CGRectGetMaxY(_photoButton.frame)+5, CHAT_BUTTON_SIZE, 15)];
    [phtotL setTextAlignment:NSTextAlignmentCenter];
    [phtotL setFont:[UIFont systemFontOfSize:12]];
    [phtotL setTextColor:UIColorFromRGB(0x999999)];
    phtotL.text = @"图片";
    phtotL.backgroundColor = [UIColor clearColor];
    [self addSubview:phtotL];
    
    
    
    
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_locationButton];
    
    UILabel *locationL = [[UILabel alloc]initWithFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, CGRectGetMaxY(_locationButton.frame)+5, CHAT_BUTTON_SIZE , 15)];
    [locationL setTextAlignment:NSTextAlignmentCenter];
    [locationL setFont:[UIFont systemFontOfSize:12]];
    [locationL setTextColor:UIColorFromRGB(0x999999)];
    locationL.text = @"位置";
    locationL.backgroundColor = [UIColor clearColor];
    [self addSubview:locationL];
    
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
    UILabel *takePicL = [[UILabel alloc]initWithFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, CGRectGetMaxY(_takePicButton.frame)+5, CHAT_BUTTON_SIZE , 15)];
    [takePicL setTextAlignment:NSTextAlignmentCenter];
    [takePicL setFont:[UIFont systemFontOfSize:12]];
    [takePicL setTextColor:UIColorFromRGB(0x999999)];
    takePicL.text = @"拍照";
    takePicL.backgroundColor = [UIColor clearColor];
    [self addSubview:takePicL];

    
    
    CGRect frame = self.frame;
    frame.size.height = 86;
    self.frame = frame;
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

@end
