//
//  CPNearViewCell.h
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPActivityModel.h"
#import "CPMyDateModel.h"
#import "CPIntersterModel.h"
#import "MultiplePulsingHaloLayer.h"
// 用于事件交互的key
#define CameraBtnClickKey   @"CameraBtnClickKey"
#define PhotoBtnClickKey    @"PhotoBtnClickKey"
#define DateBtnClickKey     @"DateBtnClickKey"
#define InvitedButtonClickKey  @"InvitedButtonClickKey"
#define IgnoreButtonClickKey   @"IgnoreButtonClickKey"
#define LoveBtnClickKey     @"LoveBtnClickKey"
#define AddressBtnClickKey  @"AddressBtnClickKey"
#define IconViewClickKey    @"IconViewClickKey"
#define TitleLabelClickKey    @"TitleLabelClickKey"
@interface CPBaseViewCell : UIView
@property (nonatomic, strong) NSIndexPath *indexPath;
// 设置不同类型的model
@property (nonatomic, strong) CPActivityModel *model;
@property (nonatomic, strong) CPMyDateModel *myDateModel;
@property (nonatomic, strong) CPIntersterModel *intersterModel;
/**
 *  更换照片按钮
 */
@property (nonatomic, strong) UIButton *changeImg;

/**
 *  继续匹配按钮
 */
@property (nonatomic, strong) UIButton *continueMatching;
/**
 *  约她
 */
@property (nonatomic, strong) UIButton *dateButton;
/**
 *  约她的动画
 */
@property (nonatomic, strong) MultiplePulsingHaloLayer *dateAnim;
+ (instancetype)baseCell;
@end
