//
//  ZYImageVIew.h
//  CarPlay
//
//  Created by chewan on 10/15/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

typedef void(^completion)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);

@interface ZYImageVIew : UIImageView
- (void)zy_setImageWithUrl:(NSString *)url completed:(completion)completed;

@property (nonatomic, strong) UIImageView *placeHloderImageView;

@property (nonatomic, strong) FXBlurView *userCoverView;
@end
