//
//  CPActivePicCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/22.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActivePicCell.h"
#import "UIImageView+WebCache.h"
#import "CPActivePhoto.h"

@interface CPActivePicCell()

@end

@implementation CPActivePicCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置图片frame
        self.pictureView.frame = CGRectMake(0, 0, 78, 78);
        [self addSubview:_pictureView];
    }
    return self;
}



// imageview懒加载
- (UIImageView *)pictureView{
    if (_pictureView == nil) {
        _pictureView = [[UIImageView alloc] init];
    }
    return _pictureView;
}

+ (NSString *)identifier{
    return @"activePicCell";
}

// 绑定图片
- (void)setActivePhoto:(CPActivePhoto *)activePhoto{
    _activePhoto = activePhoto;
    
    NSURL *url = [NSURL URLWithString:_activePhoto.thumbnail_pic];
    [self.pictureView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"imageplace"]];
}

@end
