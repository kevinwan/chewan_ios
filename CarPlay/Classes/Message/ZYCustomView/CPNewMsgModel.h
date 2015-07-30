//
//  CPNewMsgModel.h
//  CarPlay
//
//  Created by chewan on 15/7/29.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNewMsgModel : NSObject
@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) BOOL isChecked;
@end
