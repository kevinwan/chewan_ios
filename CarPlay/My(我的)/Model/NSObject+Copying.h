//
//  NSObject+Copying.h
//  CarPlay
//
//  Created by chewan on 10/29/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Copying)
- (id)copyFromSelf;
#define MJCopyingImplemention \
- (id)copyWithZone:(NSZone *)zone\
{\
    return [self copyFromSelf];\
}
@end
