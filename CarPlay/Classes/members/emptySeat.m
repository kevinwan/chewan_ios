//
//  emptySeat.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/16.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import "emptySeat.h"
#import "AppAppearance.h"
@interface emptySeat ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@end

@implementation emptySeat

- (void)awakeFromNib {
    self.titleLabel.font = [AppAppearance textLargeFont];
    self.titleLabel.textColor = [AppAppearance redColor];
    [self.cancelButton setBackgroundColor:[AppAppearance btnBackgroundColor]];
    [self.cancelButton setTitleColor:[AppAppearance textDarkColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [AppAppearance titleFont];
    self.cancelButton.layer.cornerRadius = 3;
    [self.cancelButton clipsToBounds];
    

}

@end
