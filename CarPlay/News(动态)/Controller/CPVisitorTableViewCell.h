//
//  CPVisitorTableViewCell.h
//  CarPlay
//
//  Created by jiang on 15/10/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPSexView.h"

@protocol headBtnClickdelegete <NSObject>

- (void)headBtnClicked:(UIButton *)button;

@end

@interface CPVisitorTableViewCell : UITableViewCell

@property (nonatomic, strong)CPSexView   *sexView;
@property (nonatomic, strong)UIImageView *headIV;
@property (nonatomic, strong) UILabel    *nameLabel;
@property (nonatomic, strong) UILabel    *distanceLabel;
@property (nonatomic, strong) UILabel    *timeLabel;
@property (nonatomic, strong) UILabel    *messageLabel;
@property (nonatomic, strong) UIButton   *headBtn;

@property (nonatomic, strong)UIView *selectdView;

@property (nonatomic, assign)id<headBtnClickdelegete>delegate;

@end
