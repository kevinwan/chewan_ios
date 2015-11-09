//
//  Macros.h
//  封装自用分类
//
//  Created by chewan on 15/9/16.
//  Copyright (c) 2015年 chewan. All rights reserved.
//

#ifndef _______ZYMacros_h
#define _______ZYMacros_h


#define ZYEXTENSION_EXTERN    extern
#define ZYScreenHeight        [UIScreen mainScreen].bounds.size.height  //屏幕的高度
#define ZYScreenWidth         [UIScreen mainScreen].bounds.size.width    //屏幕的宽度
#define ZYNotificationCenter [NSNotificationCenter defaultCenter]
#define ZYFont10 [UIFont systemFontOfSize:10]
#define ZYFont12 [UIFont systemFontOfSize:12]
#define ZYFont14 [UIFont systemFontOfSize:14]
#define ZYFont15 [UIFont systemFontOfSize:15]
#define ZYFont16 [UIFont systemFontOfSize:16]
#define ZYFont18 [UIFont systemFontOfSize:18]
#define ZYFont20 [UIFont systemFontOfSize:20]
#define ZYColor(r, g, b, a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a * 1.0]

#define ZYNewButton(btn)     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
#define ZYNewImageView(imgV) UIImageView *imgV = [[UIImageView alloc] init];
#define ZYNewLabel(l)        UILabel *l = [[UILabel alloc] init];

// 系统版本号
//#define SystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])   //当前设备的系统版本
//#define iOS7 (SystemVersion >= 7.0 && SystemVersion < 8.0)
//#define iOS8 (SystemVersion >= 8.0 && SystemVersion < 9.0)
//#define iOS9 (SystemVersion >= 9.0 && SystemVersion < 10.0)

#define ZYWeakSelf     @weakify(self);   // 防止block循环引用
#define ZYStrongSelf   @strongify(self); // 恢复self
#define ZYKeyWindow    (UIWindow *)([UIApplication sharedApplication].windows.lastObject)
#endif
