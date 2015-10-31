//
//  CPGroupDetailTBCell.h
//  CarPlay
//
//  Created by jiang on 15/10/30.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPSexView.h"

@protocol GroupDetailDelegeta <NSObject>

- (void)groupDetailButton:(UIButton *)button;

@end
@interface CPGroupDetailTBCell : UITableViewCell



@property (nonatomic, strong)CPSexView   *sexView;
@property (nonatomic, strong)UIImageView *headIV;
@property (nonatomic, strong) UILabel    *nameLabel;
@property (nonatomic, strong) UILabel    *distanceLabel;
@property (nonatomic, strong) UIButton    *inviteBtn;
@property (nonatomic, strong) UIButton   *SendMessageBtn;
@property (nonatomic, strong) UIButton   *TelBtn;
@property (nonatomic, assign) id<GroupDetailDelegeta>delegate;

@end
