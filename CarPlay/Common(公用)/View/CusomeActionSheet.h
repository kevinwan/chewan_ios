//
//  CusomeActionSheet.h
//  CarPlay
//
//  Created by jiang on 15/11/20.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol customActionsheetDelegete <NSObject>

- (void)btnClicked:(UIButton *)button;

@end



@interface CusomeActionSheet : UIView

@property (nonatomic,strong)UIButton *wechatFriend;//微信好友
@property (nonatomic,strong)UIButton *wechatTimeline;//朋友圈
@property (nonatomic,assign)id<customActionsheetDelegete>delegate;
@property (nonatomic,strong)UIView *shareView;
@property (nonatomic,strong)UIView *bgView;

@end
