//
//  CPBrandModelViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"

@interface CPBrandModelViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *brandTableView;
@property (nonatomic, strong) UITableView *modelTableView;
@end
