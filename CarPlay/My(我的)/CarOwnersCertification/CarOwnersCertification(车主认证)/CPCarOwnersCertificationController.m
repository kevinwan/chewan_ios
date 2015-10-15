//
//  CPCarOwnersCertificationController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPCarOwnersCertificationController.h"
#import "CPBrandModelViewController.h"

@interface CPCarOwnersCertificationController ()

@end

@implementation CPCarOwnersCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.submitBtn.layer setMasksToBounds:YES];
    [self.submitBtn.layer setCornerRadius:20.0];
    [self.navigationItem setTitle:@"车主认证"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CPBrandModelViewController *CPBrandModelVC=[[CPBrandModelViewController alloc]init];
        CPBrandModelVC.title=@"车型选择";
        [self.navigationController pushViewController:CPBrandModelVC animated:YES];
    }else{
        
    }
}
@end
