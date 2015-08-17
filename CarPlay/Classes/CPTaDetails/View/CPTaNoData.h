//
//  CPTaNoData.h
//  CarPlay
//
//  Created by 公平价 on 15/8/11.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PublishRightNow)();

@interface CPTaNoData : UIView

@property (nonatomic,copy) NSString *pictureName;

@property (nonatomic,copy) NSString *titleName;

@property (nonatomic,assign) BOOL isShowBtn;

// 发布活动代理
@property (nonatomic,copy) PublishRightNow publishRightNow;

+ (CPTaNoData *)footerView;

@end
