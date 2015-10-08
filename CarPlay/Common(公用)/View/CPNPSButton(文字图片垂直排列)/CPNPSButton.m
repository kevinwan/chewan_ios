//
//  CPNPSButton.m
//  CarPlay
//
//  Created by 公平价 on 15/10/8.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNPSButton.h"

@implementation CPNPSButton
-(void)layoutSubviews {
    [super layoutSubviews];
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    self.imageView.layer.masksToBounds=YES;
    self.imageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth=1;
    self.imageView.layer.cornerRadius=self.frame.size.width/2-10;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
}
@end
