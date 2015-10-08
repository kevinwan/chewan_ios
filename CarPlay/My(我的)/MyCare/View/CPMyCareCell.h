//
//  CPMyCareCell.h
//  CarPlay
//
//  Created by 公平价 on 15/9/28.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPCareUser.h"

@interface CPMyCareCell : UITableViewCell

@property (nonatomic,strong) CPCareUser *careUser;

+ (NSString *)identifier;


@end
