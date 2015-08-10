//
//  CPNoNetwork.m
//  CarPlay
//
//  Created by 公平价 on 15/8/8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNoNetwork.h"

@interface CPNoNetwork ()
// 网络原因
@property (weak, nonatomic) IBOutlet UILabel *reason;

// 网络原因描述
@property (weak, nonatomic) IBOutlet UILabel *reasonDescription;

@end

@implementation CPNoNetwork

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
