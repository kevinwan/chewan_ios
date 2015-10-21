//
//  CPNearCollectionViewCell.h
//  CarPlay
//
//  Created by chewan on 10/16/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBaseViewCell.h"

@interface CPNearCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) CPActivityModel *model;
@end
