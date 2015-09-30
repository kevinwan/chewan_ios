//
//  CPMyInfoController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/29.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoController.h"

@interface CPMyInfoController ()

@end

@implementation CPMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    // 设置导航栏
    [self setRightNavigationBarItemWithTitle:@"完成" Image:nil highImage:nil  target:self action:@selector(finish)];
     
}

- (void)finish{
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        //
        static NSString *firId = @"myInfoFirCell";
        cell = [tableView dequeueReusableCellWithIdentifier:firId];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoFirCell" owner:nil options:nil] lastObject];
        }
        
    }
    if (indexPath.row == 1) {
        //
        static NSString *secId = @"myInfoSecCell";
        cell = [tableView dequeueReusableCellWithIdentifier:secId];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoSecCell" owner:nil options:nil] lastObject];
        }

    }
    if (indexPath.row == 2) {
        //
        static NSString *ThrId = @"myInfoThrCell";
        cell = [tableView dequeueReusableCellWithIdentifier:ThrId];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoThrCell" owner:nil options:nil] lastObject];
        }

    }
       
    return cell;
}




@end
