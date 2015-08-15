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

@property (weak, nonatomic) IBOutlet UIButton *showButton;

- (IBAction)publishActive;


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

// 设置按钮
- (void)setIsShowBtn:(BOOL)isShowBtn{
    _isShowBtn = isShowBtn;
    
    self.showButton.layer.cornerRadius = 3;
    self.showButton.layer.masksToBounds = YES;
    
    if (!isShowBtn) {
        self.showButton.hidden = YES;
    }
}

+ (CPTaNoData *)footerView{
     return [[[NSBundle mainBundle] loadNibNamed:@"CPTaNoData" owner:nil options:nil] lastObject];
}

// 发布活动
- (IBAction)publishActive {
    if (CPUnLogin) {
        // 未登录则提示登录
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPCreatActivityController" bundle:nil];
        
//        [self.navigationController pushViewController:sb.instantiateInitialViewController animated:YES];
        
    }
}

@end
