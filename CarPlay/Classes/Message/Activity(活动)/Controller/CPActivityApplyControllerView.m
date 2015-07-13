//
//  ActivityApplyControllerView.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActivityApplyControllerView.h"
#import "CPActivityApplyCell.h"

@interface CPActivityApplyControllerView ()

@end

@implementation CPActivityApplyControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ActivityApplyCell";
    CPActivityApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    return cell;
    
}

@end
