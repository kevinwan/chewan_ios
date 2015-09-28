//
//  ViewController.m
//  自定义开关
//
//  Created by chewan on 9/28/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "ViewController.h"
#import "ZYSwitch.h"
#import "UIView+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZYSwitch *s = [ZYSwitch new];
    s.x = 200;
    s.y = 200;
    [self.view addSubview:s];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
