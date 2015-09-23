//
//  UITableView+ZYExtension.h
//  封装自用分类
//
//  Created by chewan on 15/9/11.
//  Copyright (c) 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZYExtension)

/**
 *  刷新指定的行
 *
 *  @param indexPath    indexPath
 *  @param rowAnimation 刷新动画
 */
- (void)reloadRowsAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)rowAnimation;

/**
 *  滚动表格到顶部
 */
- (void)scrollToFirstCell;

/**
 *  滚动表格到最底部
 */
- (void)scrollToLastCell;

@end
