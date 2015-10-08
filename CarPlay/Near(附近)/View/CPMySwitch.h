//
//  CPMySwitch.h
//  CarPlay
//
//  Created by chewan on 9/29/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPNoHighLightButton.h"

@interface CPMySwitch : CPNoHighLightButton

@property (nonatomic, assign) BOOL on;

- (void)setOnImage:(UIImage *)onImage;
- (void)setOffImage:(UIImage *)offImage;

@end
