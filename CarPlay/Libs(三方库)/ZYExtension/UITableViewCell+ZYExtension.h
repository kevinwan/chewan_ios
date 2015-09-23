//
//  UITableViewCell+ZYExtension.h
//  封装自用分类
//
//  Created by chewan on 15/9/11.
//  Copyright (c) 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ZYExtension)

/**
 *  封装一个加载重用cell的类方法
 *
 *  @param tableView       tableView
 *  @param reuseIdentifier 可重用标示
 *
 *  @return cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

@end
