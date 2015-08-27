//
//  CPNoData.m
//  CarPlay
//
//  Created by 公平价 on 15/8/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNoData.h"

@implementation CPNoData

+ (CPNoData *)footerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"CPNoData" owner:nil options:nil] lastObject];
}

@end
