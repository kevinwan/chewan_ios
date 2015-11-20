//
//  CusomeActionSheet.m
//  CarPlay
//
//  Created by jiang on 15/11/20.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CusomeActionSheet.h"
//152高度
@implementation CusomeActionSheet


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        
        self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceWidth, kDeviceWidth, 152)];
        _shareView.backgroundColor = UIColorFromRGB(0xfffffff);
        [self addSubview:_shareView];
   
        
        self.wechatTimeline = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatTimeline.frame = CGRectMake(40, 20, 46, 46);
        _wechatTimeline.tag = 1;
        [_wechatTimeline setImage:[UIImage imageNamed:@"wechatTimeline"] forState:UIControlStateNormal];
        [_wechatTimeline addTarget:self action:@selector(shareWeChat:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_wechatTimeline];
        
        UILabel *wechatTimeLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(40-2, CGRectGetMaxY(_wechatTimeline.frame)+10, 50, 20)];
        wechatTimeLineLabel.backgroundColor = [UIColor clearColor];
        wechatTimeLineLabel.text = @"朋友圈";
        [wechatTimeLineLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatTimeLineLabel setFont:[UIFont systemFontOfSize:12]];
        [wechatTimeLineLabel setTextColor:UIColorFromRGB(0x333333)];
        [self addSubview:wechatTimeLineLabel];
        
        
        //46
        self.wechatFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatFriend.frame = CGRectMake(CGRectGetMaxX(_wechatTimeline.frame)+50, 20, 46, 46);
        _wechatFriend.tag = 2;
        [_wechatFriend setImage:[UIImage imageNamed:@"icon_wechat"] forState:UIControlStateNormal];
        [_wechatFriend addTarget:self action:@selector(shareWeChat:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_wechatFriend];
       
        UILabel *wechatFriendLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_wechatTimeline.frame)+50-2, CGRectGetMaxY(_wechatFriend.frame)+10, 50, 20)];
        wechatFriendLabel.backgroundColor = [UIColor clearColor];
        wechatFriendLabel.text = @"微信好友";
        [wechatFriendLabel setTextAlignment:NSTextAlignmentCenter];
        [wechatFriendLabel setFont:[UIFont systemFontOfSize:12]];
        [wechatFriendLabel setTextColor:UIColorFromRGB(0x333333)];
        [self addSubview:wechatFriendLabel];
        
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(wechatFriendLabel.frame)+14, kDeviceWidth-60, 1)];
        lineview.backgroundColor = UIColorFromRGB(0xdddddd);
        [self addSubview:lineview];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(lineview.frame)+5, kDeviceWidth, 30);
        cancelBtn.tag = 3;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(shareWeChat:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        

        
    }
    return self;
}
- (void)shareWeChat:(UIButton *)button
{
    if (self.delegate && [_delegate respondsToSelector:@selector(btnClicked:)]) {
        [_delegate btnClicked:button];
    }
}

@end
