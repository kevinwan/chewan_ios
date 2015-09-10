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

#import "EMChatAudioBubbleView.h"

NSString *const kRouterEventAudioBubbleTapEventName = @"kRouterEventAudioBubbleTapEventName";

@interface EMChatAudioBubbleView ()
{
    NSMutableArray *_senderAnimationImages;
    NSMutableArray *_recevierAnimationImages;
    UIImageView    *_isReadView;
}

@end

@implementation EMChatAudioBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ANIMATION_IMAGEVIEW_SIZE, ANIMATION_IMAGEVIEW_SIZE)];
        _animationImageView.contentMode = UIViewContentModeCenter;
        _animationImageView.animationDuration = ANIMATION_IMAGEVIEW_SPEED;
        [self addSubview:_animationImageView];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont boldSystemFontOfSize:ANIMATION_TIME_LABEL_FONT_SIZE];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [Tools getColor:@"aab2bd"];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLabel];
        
        _isReadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _isReadView.layer.cornerRadius = 5;
        [_isReadView setClipsToBounds:YES];
        [_isReadView setBackgroundColor:[UIColor redColor]];
        [self addSubview:_isReadView];
        
        _senderAnimationImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_01],[UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_02], nil];
        _recevierAnimationImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_01],[UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02],nil];
    }
    return self;
}

/**
 *  调用sizetoFit时会触发
 *
 *  @param size 原来的size
 *
 */
- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat scale = (kScreenWidth - 200) / 60.0;
    CGFloat width = 0;
    
    // 如果录音时间小于60秒按照比例显示气泡的宽度
    if (self.model.time < 60.0){
        width  = 50 + self.model.time * scale;
    }else{ // 否则显示最长的宽度
        width = kScreenWidth - 200;
    }
    
    CGFloat maxHeight = MAX(ANIMATION_IMAGEVIEW_SIZE, ANIMATION_TIME_LABEL_HEIGHT);
    CGFloat height = BUBBLE_VIEW_PADDING*2 + maxHeight;
    return CGSizeMake(width, height);
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [_timeLabel sizeToFit];
    if (self.model.isSender) {
        _animationImageView.x = self.width - BUBBLE_ARROW_WIDTH - _animationImageView.width - BUBBLE_VIEW_PADDING;
        _animationImageView.y = self.height * 0.5 - _animationImageView.height * 0.5;
        
        _timeLabel.x = - _timeLabel.width - 10;

    }
    else {
        _timeLabel.x = self.width + 10;
        _animationImageView.image = [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02];
        
        _animationImageView.x = BUBBLE_ARROW_WIDTH + BUBBLE_VIEW_PADDING;
        _animationImageView.y = self.height * 0.5 - _animationImageView.height * 0.5;
        
        // 设置红点的位置
        _isReadView.x = self.width + 5;
        _isReadView.y = - 2;
        _isReadView.size = CGSizeMake(10, 10);
    }
    
    // 录音时间的位置居中
    _timeLabel.centerY = _animationImageView.centerY;
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    if (self.model.time) {
        _timeLabel.text = [NSString stringWithFormat:@"%d\"",(int)self.model.time];
    }
    
    if (self.model.isSender) {
        [_isReadView setHidden:YES];
        _animationImageView.image = [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_02];
        _animationImageView.animationImages = _senderAnimationImages;
    }
    else{
        if (model.isPlayed) {
            [_isReadView setHidden:YES];
        }else{
            [_isReadView setHidden:NO];
        }

        _animationImageView.image = [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02];
        _animationImageView.animationImages = _recevierAnimationImages;
    }
    
    if (self.model.isPlaying)
    {
        [self startAudioAnimation];
    }else {
        [self stopAudioAnimation];
    }
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventAudioBubbleTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}


+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    return 2 * BUBBLE_VIEW_PADDING + ANIMATION_IMAGEVIEW_SIZE;
}

-(void)startAudioAnimation
{
    [_animationImageView startAnimating];
}

-(void)stopAudioAnimation
{
    [_animationImageView stopAnimating];
}

@end
