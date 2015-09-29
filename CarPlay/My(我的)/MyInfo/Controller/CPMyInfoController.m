//
//  CPMyInfoController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/28.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoController.h"

@interface CPMyInfoController ()

@end

@implementation CPMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 设置导航栏
    [self setRightNavigationBarItemWithTitle:@"完成" Image:nil highImage:nil target:self action:@selector(finish)];
}

// 导航栏完成按钮
- (void)finish{
    
}

@end
