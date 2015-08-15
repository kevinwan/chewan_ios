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

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@end

@implementation CPTaNoData

// 设置图片
- (void)setPictureName:(NSString *)pictureName{
    _pictureName = pictureName;
    self.showPic.image = [UIImage imageNamed:pictureName];
}

// 设置显示文字
- (void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    self.showTitle.text = titleName;
}

+ (CPTaNoData *)footerView{
     return [[[NSBundle mainBundle] loadNibNamed:@"CPTaNoData" owner:nil options:nil] lastObject];
}

@end
