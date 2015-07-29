//
//  CPMyheaderView.m
//  CarPlay
//
//  Created by 公平价 on 15/7/24.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyheaderView.h"
#import "CPMySubscribeModel.h"
@implementation CPMyheaderView

- (IBAction)myRelease:(id)sender {
}

- (IBAction)myPayAttentionTo:(id)sender {
}

- (IBAction)myParticipateIn:(id)sender {
}

+ (instancetype)create{
    return [[[NSBundle mainBundle] loadNibNamed:@"CPMyheaderView" owner:nil options:nil] lastObject];
}

-(void)assignmentWithCPOrganizer:(CPOrganizer *)organizer{
    _organizer = organizer;
    if (_organizer) {
        if (_organizer.backGroudImgUrl) {
            NSURL *url = [[NSURL alloc]initWithString:_organizer.backGroudImgUrl];
            [self.backGroudImg sd_setImageWithURL:url];
        }
        
        if (_organizer.headImgUrl) {
            NSURL *url = [[NSURL alloc]initWithString:_organizer.headImgUrl];
            [self.userHeadImg sd_setImageWithURL:url];
        }
        
        if (_organizer.nickname) {
            UIFont *font = [UIFont systemFontOfSize:16.0f];
            CGSize size = CGSizeMake(SCREEN_WIDTH-120.0,13.0);
            CGSize labelsize = [_organizer.nickname sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            [self.nameLable setWidth:labelsize.width];
            self.nameLable.text = _organizer.nickname;
            [self.userGenderImg setX:self.nameLable.right];
        }
        
        if (!_organizer.isMan) {
            [self.userGenderImg setImage:[UIImage imageNamed:@"女-1"]];
        }
        
        if (_organizer.age) {
            self.ageLable.text=[[NSString alloc]initWithFormat:@"%ld",(long)_organizer.age];
        }
    
        if (_organizer.carBrandLogo) {
            NSURL *url=[[NSURL alloc]initWithString:_organizer.carBrandLogo];
            [self.carBrandLogoImg sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                float weight=image.size.width/image.size.height*13.0;
                [self.carBrandLogoImg setWidth:weight];
                [self.carModelAndDrivingExperience setX:self.carBrandLogoImg.right];
            }];
        }
        
        if (_organizer.carModel) {
            NSString *description=_organizer.carModel;
            if (_organizer.description) {
                description=[[NSString alloc]initWithFormat:@"%@,%@",_organizer.carModel,_organizer.description];
            }
            self.carModelAndDrivingExperience.text=description;
        }
    }
}

@end
