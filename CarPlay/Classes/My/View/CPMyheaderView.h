//
//  CPMyheaderView.h
//  CarPlay
//
//  Created by 公平价 on 15/7/24.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPOrganizer;
@interface CPMyheaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backGroudImg;
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
@property (nonatomic, strong) CPOrganizer *organizer;
+ (instancetype)create;
-(id)assignmentWithCPOrganizer:(CPOrganizer *)organizer;
@end
