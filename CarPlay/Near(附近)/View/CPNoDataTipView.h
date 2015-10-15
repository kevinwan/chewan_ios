//
//  CPNoDataTipView.h
//  CarPlay
//
//  Created by chewan on 10/15/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPNoDataTipView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

+ (instancetype)noDataTipView;
@end
