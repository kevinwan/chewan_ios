//
//  CPMyViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/9/25.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface CPMyViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *improveBtn;
- (IBAction)improveBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *headImageBg;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIButton *nickname;
@property (weak, nonatomic) IBOutlet UIButton *sex;
@property (weak, nonatomic) IBOutlet UILabel *completionLabel;
- (IBAction)myActivitiesBtnClick:(id)sender;
- (IBAction)myAttentionBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UICollectionView *albumsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *photoAuthStatus;
@property (weak, nonatomic) IBOutlet UILabel *licenseAuthStatus;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightJuli;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightJuli1;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView1;
@end
