//
//  CPGuideView.h
//  CarPlay
//
//  Created by chewan on 15/8/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  模块式的引导页View(ZYSu)

#import <UIKit/UIKit.h>

@interface CPLeadView : NSObject

+ (void)showGuideViewWithImageName:(NSString *)imageName;

+ (void)showGuideViewWithImageName:(NSString *)imageName centerX:(CGFloat)centerX y:(CGFloat)y;
@end
