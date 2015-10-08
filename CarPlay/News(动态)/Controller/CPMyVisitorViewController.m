//
//  CPMyVisitorViewController.m
//  CarPlay
//
//  Created by chewan on 9/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPMyVisitorViewController.h"
#import "CPMyVistorCell.h"

@interface CPMyVisitorViewController ()

@end

@implementation CPMyVisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [Tools getColor:@"ededf1"];
    self.navigationItem.title = @"最近访客";
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top + 10, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"VisitorCell";
    CPMyVistorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[UIStoryboard storyboardWithName:@"CPConcernMyController" bundle:nil].instantiateInitialViewController animated:YES];
}

@end
