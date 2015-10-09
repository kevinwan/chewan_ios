//
//  CPMatchingViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/9/29.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiplePulsingHaloLayer.h"

@interface CPMatchingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *nowYouWantImg;
@property (weak, nonatomic) IBOutlet UIButton *eatBtn;
@property (weak, nonatomic) IBOutlet UIButton *singBtn;
@property (weak, nonatomic) IBOutlet UIButton *movieBtn;
@property (weak, nonatomic) IBOutlet UIButton *walkDogBtn;
@property (weak, nonatomic) IBOutlet UIButton *takeExerciseBtn;
@property (weak, nonatomic) IBOutlet UIButton *supperBtn;
@property (weak, nonatomic) IBOutlet UIButton *nightclubBtn;
@property (weak, nonatomic) IBOutlet UIButton *coffeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shoppingBtn;
@property (weak, nonatomic) IBOutlet UIButton *beerBtn;
@property (weak, nonatomic) IBOutlet UIButton *takeALookBtn;
- (IBAction)btnClick:(UIButton *)sender;



/**
 * 动画
 */
@property (nonatomic, strong) MultiplePulsingHaloLayer *dateAnim;
@end
