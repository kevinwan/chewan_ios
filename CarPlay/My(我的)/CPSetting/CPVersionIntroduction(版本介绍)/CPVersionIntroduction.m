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
@property (weak, nonatomic) IBOutlet UILabel *strLabel;

@end

@implementation CPVersionIntroduction

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"版本介绍";
    self.strLabel.preferredMaxLayoutWidth = ZYScreenWidth - 80;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell layoutIfNeeded];
    return self.strLabel.bottom + 10;
}

@end
