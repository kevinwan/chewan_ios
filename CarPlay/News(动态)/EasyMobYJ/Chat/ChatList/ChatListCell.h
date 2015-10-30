/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "CPSexView.h"
@interface ChatListCell : UITableViewCell
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailMsg;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) UIImageView *interestIV;
@property (nonatomic, strong) UIImageView *HeadIV;
@property (nonatomic) NSInteger unreadCount;
//列表要增加年龄和性别的选项
@property (nonatomic, strong) CPSexView *cpSexView;
//这个属性本来是实例变量，但是设计要求如果群组的话，变成小点。所以拿出来。
@property (nonatomic, assign) BOOL isGroup;

+(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
