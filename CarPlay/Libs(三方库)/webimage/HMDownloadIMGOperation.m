//
//  HMDownloadIMGOperation.m
//  01图片下载框架
//
//  Created by itheima on 15/10/27.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HMDownloadIMGOperation.h"
#import "NSString+Path.h"
#import "UIImage+Blur.h"
#import "UIImage+BoxBlur.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+MultiFormat.h"
#import "FXBlurView.h"

@implementation HMDownloadIMGOperation
-(void)main{
    @autoreleasepool {
        
        NSLog(@"downloading %@",self.addr);
        //断言
        NSAssert(self.finishBlock != nil, @"block不为空!!!!!");
        
//        //模拟网络延时
//        [NSThread sleepForTimeInterval:1];
        
        NSURL *url = [NSURL URLWithString:self.addr];
        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:data];
//        UIImage *image = [[UIImage imageWithData:data] applyExtraLightEffect];
        UIImage *image = [[UIImage sd_imageWithData:data] blurredImageWithRadius:10 iterations:10 tintColor:[UIColor clearColor]];
//        image = [self fixOrientation:image];
        data = UIImagePNGRepresentation(image);
//        //沙盒
//        image = [UIImage imageWithData:data];
        if(data)
        [data writeToFile:[self.addr appendCachePath] atomically:YES];
        
        //取消
        if([self isCancelled]){
            NSLog(@"cancel %@",self.addr);
            return;
        }
        
        //线程间通信
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           //主线程执行
            self.finishBlock(image);
        }];
    }
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(instancetype)operationWithAddr:(NSString *)addr finishBlock:(void (^)(UIImage *))finishBlock{
    HMDownloadIMGOperation *op = [[HMDownloadIMGOperation alloc] init];
    
    op.addr = addr;
    op.finishBlock = finishBlock;
    
    return op;
}

@end
