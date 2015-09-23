//
//  UIImage+Extension.h
//  常用小功能
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 ZY_SU. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    ZYCropModeClip,     // 不会改变图像大小,多出来的不会会被裁切
    ZYCropModelExpand,  // 进行需要扩展图像大小
};
typedef NSInteger ZYCropMode;
@interface UIImage (Extension)

// 返回一张可以随意拉伸不变形的图片
+ (UIImage *)resizableImage:(NSString *)name;

/**
 *  截图神器，只需传入所要截取的控件
 *  @return 一个UIImage
 */
+ (UIImage *)imageWithCaptureView:(UIView *)view;

/**
 *  根据颜色生成图片
 *
 *  @param color 颜色
 *
 *  @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  圆形裁剪
 *  @param imageName  图片的名称
 *  @param border     边框的大小
 *  @param boderColor 边框的颜色
 *  @return           裁剪好的图片
 */
+ (UIImage *)imageWithCircleClip:(NSString *)imageName boder:(CGFloat)border color:(UIColor *)boderColor;

/**
 *  打水印  waterName 水印的图片名 scale :缩放的比例 margin :水印图的位置
 *  @param waterName 水印的图片名
 *  @param scale     水印图缩放的比例
 *  @param margin    水印图的位置
 *  @return          加入水印，大小不变的图
 */
+ (UIImage *)imageWithWaterImage:(NSString *)imageName waterImage:(NSString *)waterName scale:(CGFloat)scale margin:(CGFloat)margin;

/**
 *  添加旋转的水印图片
 *
 *  @param image      背景图
 *  @param waterImage 水印图片
 *  @param waterFrame 水印图片的位置
 *  @param angle      水印图片旋转角度
 *
 *  @return 最终的图片
 */
+ (UIImage *)imageWithBgImage:(UIImage *)bgImage waterImage:(UIImage *)waterImage frame:(CGRect)waterFrame angle:(CGFloat)angle;

/**
 *  旋转图片
 *
 *  @param radian   旋转弧度
 *  @param cropMode 裁切模式
 *
 *  @return 最终图片
 */
- (UIImage *)imageWithRotateAngle:(CGFloat)angle cropMode:(ZYCropMode)cropMode;

/**
 *  将图片写成png格式到文件
 */
- (void)writePngWithFileName:(NSString *)name atomically:(BOOL)atomically;

/**
 *  将图片写成JPG格式到文件
 *  quality : 图片质量 0.0-1.0
 */
- (void)writeJpegWithFileName:(NSString *)name Quality:(CGFloat)quality atomically:(BOOL)atomically;

/**
 *  根据图片名称加载图片,无需指定全部路径
 *
 *  @param name name
 *
 *  @return return value description
 */
+ (UIImage *)imageWithFileName:(NSString *)name;

@end
