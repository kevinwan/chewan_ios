//
//  ZYTableViewController.h
//  CarPlay
//
//  Created by chewan on 15/7/27.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//  可以将分割线全屏的tableViewController

#import <UIKit/UIKit.h>

@interface ZYTableViewController : UITableViewController

@property (nonatomic, assign) BOOL isShowNoNetWork;

/**
 *  忽略的条数
 */
@property (nonatomic, assign) NSInteger ignore;

/**
 *  显示没有网络
 */
- (void)showNoNetWork;

/**
 *  因为服务器或者其他原因导致的网络问题
 */
- (void)showNetWorkFailed;

/**
 *  显示网络超时
 */
- (void)showNetWorkOutTime;

/**
 *  显示没有加载到数据
 */
- (void)showNoData;

/**
 *  显示没有任何发布
 */
- (void)showNoPublish;

/**
 *  显示没有任何关注
 */
- (void)showNoSubscribe;

/**
 *  显示没有任何参与
 */
- (void)showNoJoin;

/**
 *  重新刷新数据,点击重新加载按钮后调用,交由子类具体实现
 */
- (void)reRefreshData;

/**
 *  去创建活动
 */
- (void)createActivity;

@end
