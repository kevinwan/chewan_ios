//
//  CPNoDataTipView.m
//  CarPlay
//
//  Created by chewan on 10/15/15.
//  Copyright © 2015 chewan. All rights reserved.
//  没有数据或者没有网络的提示View

#import "CPNoDataTipView.h"

@interface CPNoDataTipView()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic, copy) NSString *titleText;
@end

@implementation CPNoDataTipView

+ (instancetype)noDataTipViewWithTitle:(NSString *)title
{
    CPNoDataTipView *view = [[NSBundle mainBundle] loadNibNamed:@"CPNoDataTipView" owner:nil options:nil].lastObject;
    view.tipLabel.text = title;
    view.titleText = title;
    return view;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

- (void)setNetWorkFailtype:(BOOL)netWorkFailtype
{
    _netWorkFailtype = netWorkFailtype;
    
    if (netWorkFailtype) {
        self.tipLabel.text = @"加载失败了,请换个网络试试";
    }else{
        self.tipLabel.text = self.titleText;
    }
}

@end
