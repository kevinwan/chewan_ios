//
//  CPEditImageView.m
//  CarPlay
//
//  Created by chewan on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPEditImageView.h"

@interface CPEditImageView()
@property (nonatomic, weak) UIImageView *selectImage;
@end

@implementation CPEditImageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

/**
 *  进行初始化设置
 */
- (void)setUp
{
    self.userInteractionEnabled = YES;
    UIImageView *selectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中照片"]];
    [self addSubview:selectImage];
    self.selectImage = selectImage;
    self.selectImage.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat selectImageWH = self.selectImage.width;
    self.selectImage.y = self.height - 5 - selectImageWH;
    self.selectImage.x = self.selectImage.y;
}

- (void)setShowSelectImage:(BOOL)showSelectImage
{
    _showSelectImage = showSelectImage;
    
    if (showSelectImage) {
        _select = YES;
        self.selectImage.hidden = NO;
    }else{
        _select = NO;
        self.selectImage.hidden = YES;
    }
}

@end
