//
//  CPAbout.m
//  CarPlay
//
//  Created by 公平价 on 15/8/5.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPAbout.h"

@interface CPAbout ()
{
    CGSize labelsize0;
    CGSize labelsize1;
}
@end

@implementation CPAbout

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.navigationItem.title=@"关于我们";
    NSString *s0 = @"同城车主和非车主聚会，自驾游，活动神器即使你没有车，也可以邂逅身边的车主，一起自驾游，一起外出活动。还有更多各式各样的同城热闹的活动等你来参与，让自己的汽车人生更加丰富精彩！\n";
    NSString *s1 = @"创新高效、年轻激情的车玩团队始终致力于为您提供最佳的汽车移动体验。怀着对产品的无限热情，我们将不断追求完美！亲爱的车玩用户，希望您能从每一个精雕细琢的细节中体会车玩团队的用心，体验有车的生活乐趣。\n\n车玩的大未来，你我同行！\n";
    UIFont *font = [UIFont systemFontOfSize:14.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(242.0/320.0*SCREEN_WIDTH,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    labelsize0 = [s0 sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    labelsize1 = [s1 sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return labelsize0.height+82.0;
    }else{
        return labelsize1.height+74.0;
    }
    return 0;
}

- (NSInteger)numberOfSections{
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 2;
}
@end
