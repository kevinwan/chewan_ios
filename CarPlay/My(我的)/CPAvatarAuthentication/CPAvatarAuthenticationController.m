//
//  CPAvatarAuthenticationController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPAvatarAuthenticationController.h"

@interface CPAvatarAuthenticationController ()

@end

@implementation CPAvatarAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.submitBtn.layer setMasksToBounds:YES];
    [self.submitBtn.layer setCornerRadius:20.0];
    [self.navigationItem setTitle:@"头像认证"];
    [self.headImg.layer setMasksToBounds:YES];
    [self.headImg.layer setCornerRadius:3.0];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submit:(id)sender {
    
}
@end
