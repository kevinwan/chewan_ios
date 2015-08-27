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

#import "DXRecordView.h"
#import "EMCDDeviceManager.h"
@interface DXRecordView ()
{
    NSTimer *_timer;
    // 显示动画的ImageView
    UIImageView *_recordAnimationView;
    // 提示文字
    UILabel *_textLabel;
}

@end

@implementation DXRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.8;
        [self addSubview:bgView];
        
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(33, 20, self.bounds.size.width - 66, self.bounds.size.height - 64)];
        _recordAnimationView.image = [UIImage imageNamed:@"VoiceSearchFeedback001"];
        [self addSubview:_recordAnimationView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(33,
                                                               self.bounds.size.height - 34,
                                                               self.bounds.size.width - 66,
                                                               14)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = NSLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
//        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    return self;
}

// 录音按钮按下
-(void)recordButtonTouchDown
{
    // 需要根据声音大小切换recordView动画
    _textLabel.text = @"上滑取消";
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    
}
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside
{
    [_timer invalidate];
}
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside
{
    [_timer invalidate];
}
// 手指移动到录音按钮内部
-(void)recordButtonDragInside
{
    _textLabel.text = NSLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
    _textLabel.backgroundColor = [UIColor clearColor];
}

// 手指移动到录音按钮外部
-(void)recordButtonDragOutside
{
    _textLabel.text = NSLocalizedString(@"message.toolBar.record.loosenCancel", @"loosen the fingers, to cancel sending");
//    _textLabel.backgroundColor = [UIColor redColor];
}

-(void)setVoiceImage {
    _recordAnimationView.image = [UIImage imageNamed:@"VoiceSearchFeedback001"];
    double voiceSound = 0;
    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    if (0 < voiceSound <= 0.2) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback001"]];
    }else if (0.2<voiceSound<=0.21) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback001"]];
    }else if (0.21<voiceSound<=0.4) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback002"]];
    }else if (0.4<voiceSound<=0.6) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback003"]];
    }else if (0.6<voiceSound<=0.8) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback004"]];
    }else {
        [_recordAnimationView setImage:[UIImage imageNamed:@"VoiceSearchFeedback005"]];
    }
}

@end
