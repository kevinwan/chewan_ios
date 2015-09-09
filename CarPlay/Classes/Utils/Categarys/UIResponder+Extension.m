//
//  UIResponder+Extension.m
//  TestAnimation
//
//  Created by chewan on 15/8/24.
//  Copyright (c) 2015年 chewan. All rights reserved.
//  

#import "UIResponder+Extension.h"

static const char ZYModelKey = '\0';

@implementation UIResponder (Extension)

- (void)setZyModel:(id)zyModel
{
    objc_setAssociatedObject(self, &ZYModelKey, zyModel, OBJC_ASSOCIATION_ASSIGN);
}

- (id)zyModel
{
    return objc_getAssociatedObject(self, &ZYModelKey);
}


- (void)superViewRecive:(NSString *)notifyName info:(id)userInfo
{
    [[self nextResponder] superViewRecive:notifyName info:userInfo];
}

@end
