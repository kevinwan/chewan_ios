//
//  CPSelectView.h
//  CarPlay
//
//  Created by chewan on 10/12/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPSelectModel.h"

typedef void(^ConfirmBtnClick)(CPSelectModel *selectModel);
@interface CPSelectView : UIView
@property (nonatomic, copy) ConfirmBtnClick click;

/**
 *  展示筛选页面,回调数据
 *
 *  @param click 回调
 */
+ (void)showWithParams:(ConfirmBtnClick)click;

@end


