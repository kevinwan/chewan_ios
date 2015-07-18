//
//  CPHomePicCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/15.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHomePicCell.h"
#import "UIImageView+WebCache.h"
#import "CPHomePhoto.h"

@interface CPHomePicCell()
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

@end

@implementation CPHomePicCell

// 获取当前cell重用标示符
+ (NSString *)identifier{
    return @"homePicCell";
}

- (void)setHomePhoto:(CPHomePhoto *)homePhoto{
    
    _homePhoto = homePhoto;
    
    
    NSURL *url = [NSURL URLWithString:_homePhoto.thumbnail_pic];
    [self.pictureView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
}

@end
