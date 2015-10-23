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

#define CameraBtnClickKey   @"CameraBtnClickKey"
#define PhotoBtnClickKey    @"PhotoBtnClickKey"
#define DateBtnClickKey     @"DateBtnClickKey"
#define InvitedButtonClickKey  @"InvitedButtonClickKey"
#define IgnoreButtonClickKey   @"IgnoreButtonClickKey"
#define LoveBtnClickKey     @"LoveBtnClickKey"
#define AddressBtnClickKey  @"AddressBtnClickKey"
#define IconViewClickKey    @"IconViewClickKey"
@interface CPBaseViewCell : UIView
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) CPActivityModel *model;
@property (nonatomic, strong) CPMyDateModel *myDateModel;
@end
