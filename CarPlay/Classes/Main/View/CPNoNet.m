//
//  CPNoNet.m
//  CarPlay
//
//  Created by 公平价 on 15/8/11.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNoNet.h"

@interface CPNoNet ()

// 重新加载数据按钮
@property (weak, nonatomic) IBOutlet UIButton *reloadDataBtn;

// 重新加载数据点击
- (IBAction)reloadData:(id)sender;

@end

@implementation CPNoNet

- (void)awakeFromNib{
    self.reloadDataBtn.layer.cornerRadius = 3;
    self.reloadDataBtn.layer.masksToBounds = YES;
}

+ (CPNoNet *)footerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"CPNoNet" owner:nil options:nil] lastObject];
}

// 重新加载网络数据
- (IBAction)reloadData:(id)sender {
    
    if (CPNoNetWork) {
        NSLog(@"未连接网络");

    }else{
        if (self.loadHomePage != nil) {
            self.loadHomePage();
        }
    }
    
}
@end
