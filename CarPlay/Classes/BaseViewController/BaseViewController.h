//
//  lbBaseViewController.h
//  LangBo.SuiPian
//
//  Created by yabusai-mac on 14-5-26.
//  Copyright (c) 2014年 langbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController{
    double myAccountPoints;
    double REG_TIME;
    double RRICE_RATE;
    
    NSString *strUserId;
    
}


/*!
 导航栏标题
 
 @param title      显示文字
 @param titleColor 文字颜色
 */
- (void)setNavTitle:(NSString *)title titleColor:(UIColor*)titleColor;

/*!
 设置左边按钮及点击事件
 
 @param leftImage  图片名称
 @param leftAction 触发事件
 */
- (void)setLeftBarWithLeftImage:(NSString *)leftImage action:(SEL)leftAction;

/*!
 设置右边按钮及点击事件
 
 @param rightImage  图片名称
 @param rightAction 触发事件
 */
- (void)setRightBarWithRightImage:(NSString *)rightImage action:(SEL)rightAction;

/*!
 设置右边按钮及点击事件
 
 @param title       图标文字
 @param target      目标对象
 @param rightAction 触发事件
 */
- (void)setRightBarBtnWithRightTitle:(NSString *)title target:(id)target action:(SEL)rightAction;

/*!
 设置右边按钮及点击事件
 
 @param title       文字
 @param color       颜色
 @param target      对象
 @param rightAction 事件
 */
- (void)setRightBarBtnWithRightTitle:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)rightAction;



//****************************

-(void) setTitle:(NSString *) strTitle textColor:(UIColor *) color;

-(void) setLeftBar:(NSString *)imgName;

-(void) setRightBar:(NSString *)imgName;

-(void) setRightBarWithText:(NSString *)title;

-(void) setRightBarWithTextColor:(NSString *)title textColor:(UIColor *)color;

-(void) setBackBar:(NSString *)imgName;

-(void) setLeftBarWithText:(NSString *)title;
//**********

//隐藏UITableView多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView;
@end
