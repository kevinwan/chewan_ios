//
//  CPVisitorViewController.m
//  CarPlay
//
//  Created by jiang on 15/10/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPVisitorViewController.h"
#import "CPVisitorTableViewCell.h"
#import "NSDate+Category.h"
@interface CPVisitorViewController ()
{
    NSInteger _limit;
    NSInteger _page;
}
@property (nonatomic, strong)UITableView *visitorTableview;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation CPVisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _limit = 20;
    _page = 0;
    self.view.backgroundColor = GrayColor;
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.title = @"最近访客";
    self.visitorTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10) style:UITableViewStylePlain];
    _visitorTableview.delegate = self;
    _visitorTableview.dataSource  = self;
    [_visitorTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_visitorTableview];
    [self showLoading];
    
    [ZYNetWorkTool getWithUrl:[NSString stringWithFormat:@"user/%@/view/history?token=%@&limit=%ld&ignore=%ld",CPUserId,CPToken,(long)_limit,(long)_page] params:nil success:^(id responseObject) {
        [self disMiss];
        if (CPSuccess) {
            self.dataSource = [responseObject objectForKey:@"data"];
            [_visitorTableview reloadData];
        }
    } failure:^(NSError *error) {
        [self disMiss];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CareMeCell";
    CPVisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[CPVisitorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.row<self.dataSource.count) {
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        [cell.headIV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        cell.nameLabel.text = [dic objectForKey:@"nickname"];
        cell.messageLabel.text = @"看过我";
        cell.sexView.age = [[dic objectForKey:@"age"] integerValue];
        cell.sexView.gender = [dic objectForKey:@"gender"];
        cell.distanceLabel.text =[self getDidstanceStrWithDistance:[[dic objectForKey:@"distance"] integerValue]];
        
        
//        cell.timeLabel.text =[NSDate formattedTimeFromTimeInterval:[[dic objectForKey:@"subscribeTime"] longLongValue]];;
        
    }
    
    return cell;
}
- (NSString *)getDidstanceStrWithDistance:(NSInteger )distance
{
    if (distance<1000) {
        return [NSString stringWithFormat:@"%ld米",(long)distance];
    }else{
        return [NSString stringWithFormat:@"%.fkm",distance/1000.0];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row = %d",indexPath.row);
}

@end
