//
//  CPComeOnTipView.h
//  CarPlay
//
//  Created by chewan on 10/20/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRecommendModel.h"
#define CPInvitedSuccessKey @"CPInvitedSuccessKey"
@interface CPComeOnTipView : UIView
+ (void)showWithActivityId:(NSString *)activityId partMemberModel:(CPPartMember *)model;
@end
