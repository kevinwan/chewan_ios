//
//  CPMyInfoHead.m
//  CarPlay
//
//  Created by 公平价 on 15/9/30.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoHead.h"

@implementation CPMyInfoHead

+ (UIView *)createHead{
    UIView *head = [[[NSBundle mainBundle] loadNibNamed:@"CPMyInfoHead" owner:nil options:nil] lastObject];
    return head;
}

@end
