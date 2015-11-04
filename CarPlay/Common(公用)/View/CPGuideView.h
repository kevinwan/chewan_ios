//
//  CPGuideView.h
//  CarPlay
//
//  Created by chewan on 15/8/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPGuideView : NSObject

+ (void)showGuideViewWithImageName:(NSString *)imageName;
+ (void)showGuideViewWithImageName:(NSString *)imageName frame:(CGRect)frame;
@end
