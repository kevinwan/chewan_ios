//
//  CPActivityDetailFooter.h
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRecommendModel.h"

#define CPActivityComePartKey @"CPActivityComePartKey"
#define CPActivityFooterViewOpenKey @"CPActivityFooterViewOpenKey"
#define CPJionOfficeActivityKey @"CPJionOfficeActivityKey"
#define CPGroupChatClickKey @"CPGroupChatClickKey"
@interface CPActivityDetailFooterView : UIView
+ (instancetype)activityDetailFooterView;
@property (nonatomic, strong) CPRecommendModel *model;
@property (nonatomic, copy) NSString *officialActivityId;
@end
