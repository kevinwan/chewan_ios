//
//  CPTabBarController.h
//  CarPlay
//
//  Created by 公平价 on 15/6/19.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTabBarController : UITabBarController 
//{
//    EMConnectionState _connectionState;
//}

- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

//- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
@end
