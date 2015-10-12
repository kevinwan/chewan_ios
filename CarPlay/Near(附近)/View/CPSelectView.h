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
+ (void)showWithParams:(ConfirmBtnClick)click;
@property (nonatomic, copy) ConfirmBtnClick click;
@end


