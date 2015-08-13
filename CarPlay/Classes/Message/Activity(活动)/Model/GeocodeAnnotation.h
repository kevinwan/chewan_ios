//
//  GeocodeAnnotation.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-23.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface GeocodeAnnotation : NSObject<MAAnnotation>

- (id)initWithGeocode:(AMapGeocode *)geocode;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *icon;

@end
