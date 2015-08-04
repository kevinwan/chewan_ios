//
//  CPHowToPlayInfoViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/8/1.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHowToPlayInfoViewController.h"

@interface CPHowToPlayInfoViewController ()

@end

@implementation CPHowToPlayInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    self.textView.text=self.content;
}
@end
