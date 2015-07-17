//
//  CPPayButton.h
//  CarPlay
//
//  Created by chewan on 15/7/15.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPPayButton : UIButton
// 根据支付方式设置按钮
@property (nonatomic, copy) NSString *payOption;

@end
