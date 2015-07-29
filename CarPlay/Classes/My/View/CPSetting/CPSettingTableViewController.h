//
//  CPSettingTableViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSettingTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *footView;
- (IBAction)loginOutBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;

@end
