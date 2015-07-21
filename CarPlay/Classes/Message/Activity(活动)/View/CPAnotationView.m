//
//  CPAnotationView.m
//  CarPlay
//
//  Created by chewan on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPAnotationView.h"
#import "CPAnnotation.h"

@implementation CPAnotationView

+ (instancetype)annotationViewWithMapView:(MKMapView *)mapView
{
    static NSString *ID = @"annotationView";
    CPAnotationView *anotationView = (CPAnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (anotationView == nil) {
        anotationView = [[CPAnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return anotationView;
}

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        // 设置大头针标题是否显示
        self.canShowCallout = YES;
    }
    return self;
}

- (void)setAnnotation:(CPAnnotation *)annotation
{
    [super setAnnotation:annotation];
    
    self.image = [UIImage imageNamed:annotation.icon];
}

@end
