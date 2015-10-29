//
//  ZYDownloadImageOperation.m
//  CarPlay
//
//  Created by chewan on 10/28/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "ZYDownloadImageOperation.h"
#import "UIImage+Blur.h"

@interface ZYDownloadImageOperation ()
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) ZYFinishBlock finish;
@end

@implementation ZYDownloadImageOperation

- (void)main
{
    @autoreleasepool {
        
        NSAssert(self.url != nil, @"url不能为空");
        
        NSURL *url = [NSURL URLWithString:self.url];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        UIImage *blurImage = [image blurredImageWithSize:image.size];
        if (self.isCancelled) {
            return;
        }
    }
}

@end
