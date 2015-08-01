//
//  CPMyController.h
//  CarPlay
//
//  Created by 公平价 on 15/6/19.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMyController : UITableViewController
- (IBAction)photoManage:(id)sender;

- (IBAction)rightBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UIImageView *carBrandLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *carModelAndDrivingExperience;
@property (weak, nonatomic) IBOutlet UIImageView *userGenderImg;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
- (IBAction)myRelease:(id)sender;
- (IBAction)myPayAttentionTo:(id)sender;
- (IBAction)myParticipateIn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *myReleaseCountLable;
@property (weak, nonatomic) IBOutlet UILabel *myPayAttentionToCountLable;
@property (weak, nonatomic) IBOutlet UILabel *myParticipateInCountLable;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *unLoginStatusView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)leftBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *myReleaseLable;
@property (weak, nonatomic) IBOutlet UILabel *myPayAttentionToLable;
@property (weak, nonatomic) IBOutlet UILabel *myParticipateInLable;
@property (weak, nonatomic) IBOutlet UILabel *myReleaseBtnLable;
@property (weak, nonatomic) IBOutlet UILabel *myPayAttentionToBtnLable;
@property (weak, nonatomic) IBOutlet UILabel *myParticipateInBtnLable;
@end
