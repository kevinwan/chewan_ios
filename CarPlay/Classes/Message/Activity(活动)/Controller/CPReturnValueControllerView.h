//
//  CPReturnValueControllerView.h
//  CarPlay
//
//  Created by chewan on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPReturnValueControllerView : UIViewController
@property (nonatomic, copy) void (^completion)(id result);
@property (nonatomic, strong) id forValue;
@end
