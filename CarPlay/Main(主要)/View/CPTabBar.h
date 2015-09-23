//
//  CPTabBar.h
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPTabBar;
@protocol CPTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickPlusButton:(CPTabBar *)tabBar;
@end

@interface CPTabBar : UITabBar
@property (nonatomic, weak) id<CPTabBarDelegate> delegate;
@end
