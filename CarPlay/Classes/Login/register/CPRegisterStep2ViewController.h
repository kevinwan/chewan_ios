//
//  CPRegisterStep2ViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"
#import "ZHPickView.h"

@interface CPRegisterStep2ViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
- (IBAction)userIconBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtnClick;
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end
