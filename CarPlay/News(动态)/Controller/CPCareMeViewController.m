//
//  CPCareMeViewController.m
//  CarPlay
//
//  Created by jiang on 15/10/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPCareMeViewController.h"
#import "CareMeTableViewCell.h"
#import "NSDate+Category.h"
@interface CPCareMeViewController ()
@property (nonatomic, strong)UITableView *careMeTableview;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation CPCareMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GrayColor;
    self.title = @"谁关注我";
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.careMeTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,10, self.view.frame.size.width, self.view.frame.size.height-10) style:UITableViewStylePlain];
    _careMeTableview.delegate = self;

    _careMeTableview.tableFooterView = [[UIView alloc]init];
    _careMeTableview.backgroundColor = [UIColor whiteColor];
    _careMeTableview.dataSource  = self;
    [_careMeTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_careMeTableview];
    [self showLoading];
    [ZYNetWorkTool getWithUrl:[NSString stringWithFormat:@"user/%@/subscribe/history?token=%@",CPUserId,CPToken] params:nil success:^(id responseObject) {
        [self disMiss];
        if (CPSuccess) {
            self.dataSource = [responseObject objectForKey:@"data"];
            [_careMeTableview reloadData];
        }
    } failure:^(NSError *error) {
        [self disMiss];
    }];
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    CareMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[CareMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.row<self.dataSource.count) {
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        [cell.headIV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        cell.nameLabel.text = [dic objectForKey:@"nickname"];
        cell.sexView.age = [[dic objectForKey:@"age"] integerValue];
        cell.sexView.gender = [dic objectForKey:@"gender"];
        cell.distanceLabel.text =[self getDidstanceStrWithDistance:[[dic objectForKey:@"distance"] integerValue]];
        
        
        cell.timeLabel.text =[NSDate formattedTimeFromTimeInterval:[[dic objectForKey:@"subscribeTime"] longLongValue]];;

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
