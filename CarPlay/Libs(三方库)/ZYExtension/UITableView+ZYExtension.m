//
//  UITableView+ZYExtension.m
//  封装自用分类
//
//  Created by chewan on 15/9/11.
//  Copyright (c) 2015年 chewan. All rights reserved.
//

#import "UITableView+ZYExtension.h"

@implementation UITableView (ZYExtension)

- (void)reloadRowsAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
}

- (void)scrollToFirstCell
{
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)scrollToLastCell
{
    NSUInteger sectionCount = [self numberOfSections];
    
    if (sectionCount > 0) {
    
        NSUInteger rowCount = [self numberOfRowsInSection:sectionCount - 1];
        
        if (rowCount > 0) {

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount - 1 inSection:sectionCount - 1];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        
    }
    
}

@end
