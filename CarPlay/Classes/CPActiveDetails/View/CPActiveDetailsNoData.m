//
//  CPActiveDetailsNoData.m
//  CarPlay
//
//  Created by 公平价 on 15/8/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActiveDetailsNoData.h"

@implementation CPActiveDetailsNoData

+ (CPActiveDetailsNoData *)footerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"CPActiveDetailsNoData" owner:nil options:nil] lastObject];
}

@end
