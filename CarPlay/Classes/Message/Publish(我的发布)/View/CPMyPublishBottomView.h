//
//  CPMyPublishBottomView.h
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MyPublishToPlayNotify @"MyPublishToPlayNotify"
#define MyPublishToPlayInfo @"MyPublishToPlayInfo"

@class CPMyPublishModel;

@interface CPMyPublishBottomView : UIView
@property (nonatomic, strong) CPMyPublishModel *model;
@end
