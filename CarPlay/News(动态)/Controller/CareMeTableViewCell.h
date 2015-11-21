//
//  CareMeTableViewCell.h
//  CarPlay
//
//  Created by jiang on 15/10/22.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPSexView.h"

@protocol careBtnClickdelegete <NSObject>

- (void)careBtnClicked:(UIButton *)button;

@end

@interface CareMeTableViewCell : UITableViewCell
@property (nonatomic, strong)CPSexView   *sexView;
@property (nonatomic, strong)UIImageView *headIV;
@property (nonatomic, strong) UILabel    *nameLabel;
//@property (nonatomic, strong) UILabel    *distanceLabel;
//由于改吧，时间距离放到一起了。
@property (nonatomic, strong) UILabel    *timeAndDistanceLabel;

@property (nonatomic, strong)UIView *selectdView;

//添加头像认证图标
@property (nonatomic, strong)UIImageView *phohtAuthIV;
//添加车的认证图标
@property (nonatomic, strong)UIImageView *carAuthIV;

//添加关注按钮
@property (nonatomic, strong)UIButton *careBtn;
@property (nonatomic, assign)id<careBtnClickdelegete> delegate;

@end
