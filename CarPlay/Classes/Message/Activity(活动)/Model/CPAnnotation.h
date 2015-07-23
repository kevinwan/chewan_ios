//
//  CPAnnotation.h
//  CarPlay
//
//  Created by chewan on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CPLocationModel;
@interface CPAnnotation : NSObject<MKAnnotation>
/**
 *  大头针的位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/**
 *  大头针标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  大头针的子标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  记录我需要的位置
 */
@property (nonatomic, strong) CPLocationModel *model;

@end
