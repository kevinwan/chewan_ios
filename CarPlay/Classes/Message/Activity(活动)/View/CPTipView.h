//
//  CPTipView.h
//  CarPlay
//
//  Created by chewan on 15/8/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completion)();
typedef void(^cancle)();
@interface CPTipView : UIView

+ (void)showWithConfirm:(completion)completion cancle:(cancle)cancle;

@end
