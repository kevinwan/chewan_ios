//
//  UIImage+Extension.m
//  ZY_SU
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 ZY_SU. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

+ (UIImage *)imageWithCaptureView:(UIView *)view
{
    // 创建上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    // 将View的图层写入到上下文中
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 获得上下文中的图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithCircleClip:(NSString *)imageName boder:(CGFloat)border color:(UIColor *)boderColor
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGFloat sizeW = image.size.width + border * 2;
    CGFloat sizeH = image.size.height + border * 2;
    CGSize size =  CGSizeMake(sizeW, sizeH);
    // 创建bit上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    
    // 画出外边的大圆
    [boderColor set];
    CGFloat bigX = sizeW * 0.5;
    CGFloat bigY = sizeH * 0.5;
    CGFloat radius = bigX;
    CGContextAddArc(ctf, bigX, bigY, radius, 0, M_PI * 2, NO);
    
    // 将上下文渲染到图层
    CGContextFillPath(ctf);
    
    // 画小圆
    CGFloat smallX = bigX;
    CGFloat smallY = bigY;
    CGContextAddArc(ctf, smallX, smallY, radius - border, 0, M_PI * 2, NO);
    CGContextClip(ctf);
    
    // 画图
    [image drawInRect:CGRectMake(border, border, image.size.width, image.size.height)];
    
    // 获得上下文中的图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithWaterImage:(NSString *)imageName waterImage:(NSString *)waterName scale:(CGFloat)scale margin:(CGFloat)margin
{
    UIImage *bgImage = [UIImage imageNamed:imageName];
    
    // 创建图形上下文，一般大小为图片的大小
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    
    // 画背景图到上下文
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 添加水印到上下文
    UIImage *water = [UIImage imageNamed:waterName];
    
    CGFloat waterW = water.size.width * scale;
    CGFloat waterH = water.size.height * scale;
    CGFloat waterX = bgImage.size.width - waterW - margin;
    CGFloat waterY = bgImage.size.height - waterH - margin;
    
    [water drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    // 获得上下文中的图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage*)imageWithRotateAngle:(CGFloat)angle cropMode:(ZYCropMode)cropMode
{
    CGSize imgSize = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    CGSize outputSize = imgSize;
    if (cropMode == ZYCropModelExpand) {
        CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(angle));
        outputSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
    
    UIGraphicsBeginImageContext(outputSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    
    [self drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithBgImage:(UIImage *)bgImage waterImage:(UIImage *)waterImage frame:(CGRect)waterFrame angle:(CGFloat)angle
{
    // 创建图形上下文，一般大小为图片的大小
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    
    // 画背景图到上下文
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 添加水印到上下文
    UIImage *water = [waterImage imageWithRotateAngle:angle cropMode:ZYCropModeClip];
    
    [water drawInRect:waterFrame];
    
    // 获得上下文中的图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)writePngToFile:(NSString *)path atomically:(BOOL)atomically
{
    [UIImagePNGRepresentation(self) writeToFile:path atomically:atomically];
}

- (void)writeJpegToFile:(NSString *)path Quality:(CGFloat)quality atomically:(BOOL)atomically
{
    [UIImageJPEGRepresentation(self, quality) writeToFile:path atomically:atomically];
}

+ (UIImage *)imageWithFileName:(NSString *)name
{
    NSData *data = [NSData dataWithContentsOfFile:CPDocmentPath(name)];
    return [UIImage imageWithData:data];
}

@end
