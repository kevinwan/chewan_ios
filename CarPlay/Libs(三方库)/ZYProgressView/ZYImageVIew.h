//
//  ZYImageVIew.h
//  CarPlay
//
//  Created by chewan on 10/15/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "UIImageView+WebCache.h"
typedef void(^completion)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);

@interface ZYImageVIew : UIImageView
- (void)zy_setImageWithUrl:(NSString *)url;
- (void)zy_setBlurImageWithUrl:(NSString *)url;

@property (nonatomic, strong) UIImageView *placeHloderImageView;

@property (nonatomic, strong) FXBlurView *userCoverView;
@property (nonatomic, assign) BOOL showBlurView;
@end
