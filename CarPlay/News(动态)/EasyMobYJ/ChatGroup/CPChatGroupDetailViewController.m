//
//  CPChatGroupDetailViewController.m
//  CarPlay
//
//  Created by jiang on 15/10/30.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPChatGroupDetailViewController.h"

@interface CPChatGroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *membersTableview;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation CPChatGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GrayColor;
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.title = @"成员";
    [self initTableview];

}


- (void)initTableview
{
    self.membersTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10) style:UITableViewStylePlain];
    _membersTableview.delegate = self;
    _membersTableview.dataSource  = self;
    [_membersTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_membersTableview];
    
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
    CPGroupDetailTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//    
//    if (!cell) {
//        cell = [[CPGroupDetailTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
//    }
//    if (indexPath.row<self.dataSource.count) {
//        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
//        [cell.headIV zySetImageWithUrl:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
//        cell.nameLabel.text = [dic objectForKey:@"nickname"];
//        cell.messageLabel.text = @"看过我";
//        cell.sexView.age = [[dic objectForKey:@"age"] integerValue];
//        cell.sexView.gender = [dic objectForKey:@"gender"];
//        cell.distanceLabel.text =[self getDidstanceStrWithDistance:[[dic objectForKey:@"distance"] integerValue]];
//        
//        
//        //        cell.timeLabel.text =[NSDate formattedTimeFromTimeInterval:[[dic objectForKey:@"subscribeTime"] longLongValue]];;
//        
//    }
    
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
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
