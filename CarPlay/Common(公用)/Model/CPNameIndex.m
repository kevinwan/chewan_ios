//
//  CPNameIndex.m
//  CarPlay
//
//  Created by 公平价 on 15/10/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNameIndex.h"
#import "CPpinyin.h"

@implementation CPNameIndex

@synthesize _firstName, _lastName;
@synthesize _sectionNum, _originIndex;

- (NSString *) getFirstName {
    if ([_firstName canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英文
        return _firstName;
    }
    else { //如果是非英文
        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_firstName characterAtIndex:0])];
    }
    
}
- (NSString *) getLastName {
    if ([_lastName canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return _lastName;
    }
    else {
        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_lastName characterAtIndex:0])];
    }
    
}

@end
