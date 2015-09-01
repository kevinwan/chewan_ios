//
//  CPActiveDetailsController.h
//  CPActiveDetailsDemo
//
//  Created by 公平价 on 15/7/1.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPActiveDetailsController : UIViewController

// 存储活动ID
@property (nonatomic,copy) NSString *activeId;

// 是否为官方活动
@property (nonatomic,assign) BOOL isOfficialActivity;

// 是不是从创建活动页跳转过来的
@property (nonatomic, assign) BOOL isFromCreateActivity;

@end
