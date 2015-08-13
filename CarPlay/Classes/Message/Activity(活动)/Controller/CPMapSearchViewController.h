//
//  CPMapSearchViewController.h
//  CarPlay
//
//  Created by chewan on 15/8/12.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  搜索地点的viewController

#import <UIKit/UIKit.h>

@interface CPMapSearchViewController : UITableViewController
@property (nonatomic, copy) void (^search)(id result);
@property (nonatomic, copy) void (^go)(id result);
@property (nonatomic, copy) void (^look)(id result);
@property (nonatomic, strong) id forValue;
@end
