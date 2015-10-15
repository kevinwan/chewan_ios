//
//  CPVersionIntroduction.m
//  CarPlay
//
//  Created by 公平价 on 15/8/5.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPVersionIntroduction.h"

@interface CPVersionIntroduction ()
{
    CGSize labelsize;
}
@end

@implementation CPVersionIntroduction

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"版本介绍";
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    NSString *s = @"同城活动：最火爆的同城车友活动，自驾游吃饭...约上附近的车友一起各种happy\n\n发布活动：不管你有车还是没有车都可以参加\n\n抢车座：加入活动可以抢坐在男神女神旁边活动成员聊天；活动的成员可以聚在一起，成为朋友\n\n车主认证：如果你有车，你就可以认证车主通过以后你将会更加有吸引力";
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    //设置一个行高上限
    CGSize size = CGSizeMake(242.0/320.0*ZYScreenWidth,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return labelsize.height+81.0;
}

@end
