//
//  CPTaInfo.h
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTaInfo : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImgBg;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *headStatus;
@property (weak, nonatomic) IBOutlet UIButton *nickname;
@property (weak, nonatomic) IBOutlet UIButton *sexAndAge;
@property (weak, nonatomic) IBOutlet UIImageView *carLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
- (IBAction)attentionBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *noImgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadBtnClick:(id)sender;

- (IBAction)taActivityClick:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *albumsCollectionView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) NSString *userId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carNameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carLogoCenter;

@end
