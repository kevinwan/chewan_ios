//
//  carCell.h
//  参与成员
//
//  Created by Jia Zhao on 15/7/14.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cars.h"
@interface carManageCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *seatMain;
@property (weak, nonatomic) IBOutlet UIButton *seatone;
@property (weak, nonatomic) IBOutlet UIButton *seatTwo;
@property (weak, nonatomic) IBOutlet UIButton *seatThree;
@property (nonatomic, strong) NSString *totalSeat;
@property (nonatomic, strong) cars *models;
@end
