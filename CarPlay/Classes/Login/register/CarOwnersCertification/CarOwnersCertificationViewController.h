//
//  CarOwnersCertificationViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"
#import "ZHPickView.h"
#import "CPMySubscribeModel.h"

@interface CarOwnersCertificationViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageBtn;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextBtnClick:(id)sender;
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)NSString *fromMy;
@property(nonatomic,strong) CPOrganizer *organizer;
@end
