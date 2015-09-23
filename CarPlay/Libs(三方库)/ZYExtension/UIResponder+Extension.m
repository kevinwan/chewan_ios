//
//  UIResponder+Extension.m
//  TestAnimation
//
//  Created by chewan on 15/8/24.
//  Copyright (c) 2015年 chewan. All rights reserved.
//  

#import "UIResponder+Extension.h"
#import <objc/runtime.h>

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


- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if (self.nextResponder) {
        
        [[self nextResponder] superViewWillRecive:notifyName info:userInfo];
    }
}

@end
