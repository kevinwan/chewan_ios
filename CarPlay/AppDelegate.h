//
//  AppDelegate.h
//  CarPlay
//
//  Created by chewan on 15/9/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CPTabBarController *tabVc;
@property (nonatomic, assign) BOOL login;
@end

