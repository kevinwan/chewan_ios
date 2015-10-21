//
//  CPNameIndex.h
//  CarPlay
//
//  Created by 公平价 on 15/10/19.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNameIndex : NSObject{
    NSString *_lastName;
    NSString *_firstName;
    NSString *_code;
    NSInteger _sectionNum;
    NSInteger _originIndex;
}
@property (nonatomic, retain) NSString *_lastName;
@property (nonatomic, retain) NSString *_firstName;
@property (nonatomic, retain) NSString *_code;
@property (nonatomic) NSInteger _sectionNum;
@property (nonatomic) NSInteger _originIndex;
- (NSString *) getFirstName;
- (NSString *) getLastName;

@end
