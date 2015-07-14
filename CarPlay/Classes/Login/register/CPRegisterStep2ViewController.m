//
//  CPRegisterStep2ViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPRegisterStep2ViewController.h"

@interface CPRegisterStep2ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CPRegisterStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
# pragma UITableViewDataSource   UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *baseCellIdentifier=@"baseCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:baseCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier: baseCellIdentifier];
    }
    cell.textLabel.tintColor=[Tools getColor:@"aab2bd"];
    cell.textLabel.text=@"昵称";
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
