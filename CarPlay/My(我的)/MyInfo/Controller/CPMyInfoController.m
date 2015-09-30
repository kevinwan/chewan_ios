//
//  CPMyInfoController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/29.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoController.h"
#import "CPMyInfoFirCell.h"
#import "CPMyInfoSecCell.h"
#import "CPMyInfoThrCell.h"

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
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //
        static NSString *firId = @"myInfoFirCell";
        CPMyInfoFirCell *cell = [tableView dequeueReusableCellWithIdentifier:firId];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoFirCell" owner:nil options:nil] lastObject];
        }
        return cell;
        
    }else if (indexPath.row == 1) {
        //
        static NSString *secId = @"myInfoSecCell";
        CPMyInfoSecCell *cell = [tableView dequeueReusableCellWithIdentifier:secId];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoSecCell" owner:nil options:nil] lastObject];
        }
        return cell;

    }else if (indexPath.row == 2) {
        //
        static NSString *ThrId = @"myInfoThrCell";
        CPMyInfoThrCell *cell = [tableView dequeueReusableCellWithIdentifier:ThrId];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoThrCell" owner:nil options:nil] lastObject];
        }
        return cell;

    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [Tools getColor:@"efefef"];
        return cell;
    }
       

}




@end
