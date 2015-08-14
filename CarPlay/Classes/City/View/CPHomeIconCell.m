//
//  CPHomeIconCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHomeIconCell.h"
#import "CPHomeMember.h"
#import "UIImageView+WebCache.h"

@interface CPHomeIconCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic,strong) UIButton *countBtn;
@end

@implementation CPHomeIconCell
// 获取当前cell重用标示符
+ (NSString *)identifier{
    return @"homeMemCell";
}

- (UIButton *)countBtn{
    if (!_countBtn) {
        _countBtn = [[UIButton alloc] init];
        _countBtn.frame = CGRectMake(0, 0, 25, 25);
    }
    return _countBtn;
}

- (void)setHomeMember:(CPHomeMember *)homeMember{
    _homeMember = homeMember;
    
    self.iconView.layer.cornerRadius = 12.5;
    self.iconView.layer.masksToBounds = YES;
    
    NSURL *url = [NSURL URLWithString:_homeMember.photo];
    [self.iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    if ([homeMember.photo isEqualToString:@"用户小头像底片"]) {

        UIImage *tempImage = [UIImage imageNamed:homeMember.photo];
        NSString *tempMembers = [NSString stringWithFormat:@"%ld",homeMember.membersCount];
        self.iconView.image = [self addText:tempImage text:tempMembers];
    
    }
    
    
//    // 添加按钮后取出头像图片
//    self.iconView.image = [UIImage imageNamed:activeMember.photo];
    
//    if ([homeMember.photo isEqualToString:@"用户小头像底片"]) {
//        NSString *iconCount = [NSString stringWithFormat:@"%@",@(homeMember.membersCount)];
//        [self.countBtn setTitle:iconCount forState:UIControlStateNormal];
//        [self.iconView addSubview:self.countBtn];
//    }
   
    
   
    
    
}


-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Arial", 14, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
    CGContextShowTextAtPoint(context, w/2-strlen(text)*5 +1.9, h/2 -4, text, strlen(text));
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}

@end
