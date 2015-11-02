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
/**
 *  展示View
 *
 *  @param activityId 活动的activityId
 *  @param model      对应cell的model
 */
+ (void)showWithActivityId:(NSString *)activityId partMemberModel:(CPPartMember *)model;

@end
