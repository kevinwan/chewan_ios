//
//  CPActivePhoto.h
//  CarPlay
//
//  Created by 公平价 on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPActivePhoto : NSObject

/** 缩略图 */
@property (nonatomic, copy) NSString *thumbnail_pic;

// 原图
@property (nonatomic, copy) NSString *original_pic;

// coverId
@property (nonatomic,copy) NSString *coverId;

@end
