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
@end
