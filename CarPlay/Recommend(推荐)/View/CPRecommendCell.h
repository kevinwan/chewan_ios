//
//  CPRecommendCell.h
//  CarPlay
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRecommendModel.h"
#define RecommentAddressClickKey @"RecommentAddressClickKey"
@interface CPRecommendCell : UIView
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) CPRecommendModel *model;
@end
