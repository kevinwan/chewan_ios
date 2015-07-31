//
//  CPBrandModelViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"
#import "MJNIndexView.h"
#import "CustomSectionView.h"

@interface CPBrandModelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *brandTableView;
@property (nonatomic, strong) UITableView *modelTableView;
@property (nonatomic, strong) MJNIndexView *indexView;
@property (nonatomic, strong) UIView *modelSlideView;
@property (nonatomic, strong) CustomSectionView *sectionView;
@end
