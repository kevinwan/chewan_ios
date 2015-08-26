//
//  CPModelButton.h
//  CarPlay
//
//  Created by chewan on 15/8/15.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPModelButton : UIButton
@property (nonatomic, assign) id model;
@property (nonatomic, strong) NSIndexPath *path;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *button;
@end
