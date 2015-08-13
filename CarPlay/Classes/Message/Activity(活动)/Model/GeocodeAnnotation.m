//
//  GeocodeAnnotation.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-23.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "GeocodeAnnotation.h"

@interface GeocodeAnnotation ()

@property (nonatomic, strong) AMapGeocode *geocode;

@end

@implementation GeocodeAnnotation

#pragma mark - Life Cycle

- (id)initWithGeocode:(AMapGeocode *)geocode
{
    if (self = [super init])
    {
        self.geocode = geocode;
        self.title = geocode.building;
        self.subtitle = geocode.formattedAddress;
        self.coordinate = CLLocationCoordinate2DMake(geocode.location.latitude, geocode.location.longitude);
    }
    
    return self;
}

@end
