//
//  carCell.h
//  参与成员
//
//  Created by Jia Zhao on 15/7/14.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cars.h"
@interface carCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *seatMain;
@property (weak, nonatomic) IBOutlet UIButton *seatone;
@property (weak, nonatomic) IBOutlet UIButton *seatTwo;
@property (weak, nonatomic) IBOutlet UIButton *seatThree;
@property (weak, nonatomic) IBOutlet UIButton *seatLastOne;
@property (weak, nonatomic) IBOutlet UIButton *seatLastTwo;
@property (weak, nonatomic) IBOutlet UIButton *seatLastThree;
@property (nonatomic, strong) cars *models;
@end