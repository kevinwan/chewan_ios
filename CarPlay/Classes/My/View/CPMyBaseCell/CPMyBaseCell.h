//
//  CPMyBaseCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMyBaseCell : ZYTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *valueLable;
@property (weak, nonatomic) IBOutlet UIImageView *carBrandLogoImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLableW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLableRight;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carBrandLogoImgRight;

@end
