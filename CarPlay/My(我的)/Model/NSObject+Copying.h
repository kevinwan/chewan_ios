//
//  NSObject+Copying.h
//  CarPlay
//
//  Created by chewan on 10/29/15.
//  Copyright © 2015 chewan. All rights reserved.
//  扩展MJExtension 添加一句话copy对象的宏

#import <Foundation/Foundation.h>

@interface NSObject (Copying)

/**
 *  从self copy出新的对象
 *
 *  @return 新的对象
 */
- (id)copyFromSelf;

#define MJCopyingImplemention \
- (id)copyWithZone:(NSZone *)zone\
{\
    return [self copyFromSelf];\
}
@end
