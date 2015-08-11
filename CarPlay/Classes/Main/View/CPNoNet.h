//
//  CPNoNet.h
//  CarPlay
//
//  Created by 公平价 on 15/8/11.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoadHomePage)();

@interface CPNoNet : UIView

+ (CPNoNet *)footerView;

@property (nonatomic,copy) LoadHomePage loadHomePage;

@end
