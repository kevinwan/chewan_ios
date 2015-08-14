//
//  offerCar.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/14.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import "offerCar.h"
#import "AppAppearance.h"
@interface offerCar () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *carxibViewOne;
@property (weak, nonatomic) IBOutlet UIView *carxibViewThree;

@property (weak, nonatomic) IBOutlet UILabel *carxibLblOne;
@property (weak, nonatomic) IBOutlet UILabel *carxibLblTwo;
@property (weak, nonatomic) IBOutlet UILabel *carxibLblThree;
@property (weak, nonatomic) IBOutlet UIButton *carxibButton;

@property (weak, nonatomic) IBOutlet UILabel *carxibLblge;
@property (weak, nonatomic) IBOutlet UILabel *carxibLblNO;
@property (weak, nonatomic) IBOutlet UILabel *carxibLblYES;



@end
@implementation offerCar

- (void)awakeFromNib {
    self.carxibViewOne.layer.borderColor = [[AppAppearance lineColor]CGColor];
    self.carxibViewOne.layer.borderWidth = 0.5;
    self.carxibViewThree.layer.borderColor = [[AppAppearance lineColor]CGColor];
    self.carxibViewThree.layer.borderWidth = 0.5;
    self.carxibLblOne.font = [AppAppearance textLargeFont];
    self.carxibLblOne.textColor = [AppAppearance textDarkColor];
    self.carxibLblTwo.font = [AppAppearance textMediumFont];
    self.carxibLblTwo.textColor = [AppAppearance textMediumColor];
    self.carxibLblThree.font = [AppAppearance textMediumFont];
    self.carxibLblThree.textColor = [AppAppearance textMediumColor];
    self.carxibLblge.font = [AppAppearance textLargeFont];
    self.carxibLblge.textColor = [AppAppearance textDarkColor];
        self.carxibLblYES.font = [AppAppearance textMediumFont];
    self.carxibLblYES.textColor = [AppAppearance redColor];
    self.carxibLblNO.font = [AppAppearance textMediumFont];
    self.carxibLblNO.textColor = [AppAppearance textMediumColor];
    [self.carxibButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    [self.carxibButton setBackgroundColor:[AppAppearance greenColor]];
    self.carxibButton.layer.cornerRadius = 3;
    [self.carxibButton clipsToBounds];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}



@end
