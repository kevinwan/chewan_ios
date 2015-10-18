//
//  CPNoDataTipView.h
//  CarPlay
//
//  Created by chewan on 10/15/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPNoDataTipView : UIView

@property (nonatomic, assign) BOOL netWorkFailtype;

+ (instancetype)noDataTipViewWithTitle:(NSString *)title;

@end
