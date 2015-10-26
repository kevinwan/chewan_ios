//
//  CPActivityPartnerCell.h
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRecommendModel.h"
#define CPClickUserIcon @"CPClickUserIcon"
#define CPOfficeActivityMsgButtonClick @"CPOfficeActivityMsgButtonClick"
#define CPOfficeActivityPhoneButtonClick @"CPOfficeActivityPhoneButtonClick"
@interface CPActivityPartnerCell : ZYTableViewCell
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, strong) CPPartMember *model;
@end
