//
//  CPTaNoData.m
//  CarPlay
//
//  Created by 公平价 on 15/8/11.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaNoData.h"

@interface CPTaNoData ()
@property (weak, nonatomic) IBOutlet UIImageView *showPic;

@end

@implementation CPTaNoData

// 设置图片
- (void)setPictureName:(NSString *)pictureName{
    _pictureName = pictureName;
    self.showPic.image = [UIImage imageNamed:pictureName];
}

+ (CPTaNoData *)footerView{
     return [[[NSBundle mainBundle] loadNibNamed:@"CPTaNoData" owner:nil options:nil] lastObject];
}

@end
