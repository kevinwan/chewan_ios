//
//  CPActivityDetailHeaderView.h
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRecommendModel.h"

#define CPActivityDetailHeaderDetailOpenKey @"CPActivityDetailHeaderDetailOpenKey"
@interface CPActivityDetailHeaderView : UIView

+ (instancetype)activityDetailHeaderView;

@property (nonatomic, strong) CPRecommendModel *model;

@end
