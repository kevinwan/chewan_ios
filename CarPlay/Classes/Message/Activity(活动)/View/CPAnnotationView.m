//
//  CPAnnotationView.m
//  CarPlay
//
//  Created by chewan on 15/8/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPAnnotationView.h"

@implementation CPAnnotationView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected){
        self.image = [UIImage imageNamed:@"定位"];
    }else{
        self.image = [UIImage imageNamed:@"定位蓝"];
    }
    [super setSelected:selected animated:animated];
}

@end
