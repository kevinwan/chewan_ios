//
//  UITableViewCell+ZYExtension.m
//  封装自用分类
//
//  Created by chewan on 15/9/11.
//  Copyright (c) 2015年 chewan. All rights reserved.
//

#import "UITableViewCell+ZYExtension.h"

@implementation UITableViewCell (ZYExtension)

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    return cell;
}

@end
