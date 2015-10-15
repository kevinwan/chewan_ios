//
//  CPAvatarAuthenticationController.h
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPAvatarAuthenticationController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submit:(id)sender;
@end
