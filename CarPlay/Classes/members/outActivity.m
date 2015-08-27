//
//  outActivity.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/24.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import "outActivity.h"
#import "AppAppearance.h"
@interface outActivity ()
@property (weak, nonatomic) IBOutlet UILabel *outActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *outActivityLabelTwo;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;



@end

@implementation outActivity
- (void)awakeFromNib {
    self.outActivityLabel.textColor = [AppAppearance labelPromptColor];
    self.outActivityLabelTwo.textColor = [AppAppearance labelPromptColor];
    [self.cancelButton setTitleColor:[AppAppearance textDarkColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:[AppAppearance btnBackgroundColor]];
    self.cancelButton.layer.cornerRadius = 3;
    self.cancelButton.layer.masksToBounds = YES;
    [self.sureButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:[AppAppearance greenColor]];
    self.sureButton.layer.cornerRadius = 3;
    self.sureButton.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;

}


@end
