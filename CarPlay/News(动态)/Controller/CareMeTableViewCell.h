//
//  CareMeTableViewCell.h
//  CarPlay
//
//  Created by jiang on 15/10/22.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPSexView.h"
@interface CareMeTableViewCell : UITableViewCell
@property (nonatomic, strong)CPSexView   *sexView;
@property (nonatomic, strong)UIImageView *headIV;
@property (nonatomic, strong) UILabel    *nameLabel;
@property (nonatomic, strong) UILabel    *distanceLabel;
@property (nonatomic, strong) UILabel    *timeLabel;

@property (nonatomic, strong)UIView *selectdView;

//添加头像认证图标
@property (nonatomic, strong)UIImageView *phohtAuthIV;
//添加车的认证图标
@property (nonatomic, strong)UIImageView *carAuthIV;

@end
