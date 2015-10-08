//
//  CPConcernMyController.m
//  CarPlay
//
//  Created by chewan on 9/30/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPConcernMyController.h"
#import "CPConcernMyCell.h"

@interface CPConcernMyController ()
@property (nonatomic, assign) NSUInteger count;
@end

@implementation CPConcernMyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [Tools getColor:@"ededf1"];
    self.navigationItem.title = @"谁关注我";
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.count = 3;
    UILabel *titleText = [UILabel labelWithText:@"互相关注可以聊天" textColor:[Tools getColor:@"333333"] fontSize:16];
    titleText.textAlignment = NSTextAlignmentCenter;
    [self.tableView insertSubview:titleText atIndex:0];
    [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.tableView);
        make.height.equalTo(@35);
        make.top.equalTo(self.tableView);
    }];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.header endRefreshing];
            self.count += 3;
            [self.tableView reloadData];
        });
        
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter    footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
            self.count += 3;
            if (self.count > 20) {
                [self.tableView.footer noticeNoMoreData];
            }
            [self.tableView reloadData];
        });
        
    }];
    
    [[self rac_signalForSelector:@selector(tableView:numberOfRowsInSection:) fromProtocol:@protocol(UITableViewDataSource)] subscribeNext:^(id x) {
        NSLog(@"来了");
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ConcernCell";
    CPConcernMyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    return cell;
}
@end
