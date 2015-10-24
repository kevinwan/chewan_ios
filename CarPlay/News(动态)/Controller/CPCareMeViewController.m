//
//  CPCareMeViewController.m
//  CarPlay
//
//  Created by jiang on 15/10/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPCareMeViewController.h"
#import "CareMeTableViewCell.h"
@interface CPCareMeViewController ()
@property (nonatomic, strong)UITableView *careMeTableview;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation CPCareMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GrayColor;
    self.careMeTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, kDeviceWidth, KDeviceHeight-64-20)];
    _careMeTableview.delegate = self;
    _careMeTableview.dataSource  = self;
    [self showLoading];
    [ZYNetWorkTool getWithUrl:[NSString stringWithFormat:@"user/%@/subscribe/history?token=%@",CPUserId,CPToken] params:nil success:^(id responseObject) {
        if (CPSuccess) {
            self.dataSource = [responseObject objectForKey:@"data"];
//            [_careMeTableview reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CareMeCell";
    CareMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[CareMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    
    return cell;
}

@end
