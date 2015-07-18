//
//  CPCreatActivityController.m
//  CarPlay
//
//  Created by chewan on 15/7/18.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  创建活动

#import "CPCreatActivityController.h"
#import "CPCreatActivityCell.h"
#import "CPActivityNameController.h"
@interface CPCreatActivityController ()
@property (nonatomic, weak) UIView *lastArrow;
@property (nonatomic, strong) NSMutableArray *activivtyDatas;
@property (nonatomic, assign) CGFloat photoViewHeight;
@end

@implementation CPCreatActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建活动";
    
    [self setUpCellOperation];
}

/**
 *  进行cell操作的封装
 */
- (void)setUpCellOperation
{
    self.photoViewHeight = 100;
    CPCreatActivityCell *activityTypeCell = [self cellWithRow:0];
    activityTypeCell.operation = ^{
        
        
    };
    CPCreatActivityCell *activityNameCell = [self cellWithRow:1];
    activityNameCell.destClass = [CPActivityNameController class];
    
    CPCreatActivityCell *activityPhotoCell = [self cellWithRow:2];
    UIButton *addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoBtn.frame = CGRectMake(10, 10, 78, 78);
    [addPhotoBtn setBackgroundColor:[Tools getColor:@"ccd1d9"]];
    [addPhotoBtn setImage:[UIImage imageNamed:@"拍照"] forState:UIControlStateNormal];
    [activityPhotoCell.contentView addSubview:addPhotoBtn];

    
    CPCreatActivityCell *activityLocationCell = [self cellWithRow:3];
    activityLocationCell.destClass = nil;
    
    
    CPCreatActivityCell *activityStartCell = [self cellWithRow:4];
    activityStartCell.operation = ^{
        NSLog(@"活动ss类型");
    };
    
    
    CPCreatActivityCell *activityEndCell = [self cellWithRow:5];
    activityEndCell.operation = ^{
        NSLog(@"活动d类型");
    };
    
    
    CPCreatActivityCell *activityPayCell = [self cellWithRow:6];
    activityPayCell.operation = ^{
        NSLog(@"活动类fd型");
    };
    
    
    CPCreatActivityCell *activitySeatCell = [self cellWithRow:7];
    activitySeatCell.operation = ^{
        NSLog(@"活动dfsf类型");
    };
    
}

/**
 *  返货获取到得cell
 *
 *  @param row 行号
 */
- (CPCreatActivityCell *)cellWithRow:(NSUInteger)row
{
    return  (CPCreatActivityCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPCreatActivityCell *cell = [self cellWithRow:indexPath.row];
    if (cell.operation) {
        cell.operation();
        [self rotationArrow:[cell viewWithTag:111]];
        return;
    }
    if (cell.destClass){
        [self.navigationController pushViewController:[[cell.destClass alloc] init] animated:YES];
    }
}

/**
 *  旋转箭头的方法
 */
- (void)rotationArrow:(UIView *)arrow
{
    if (self.lastArrow == arrow) {
        arrow.transform = CGAffineTransformIdentity;
        self.lastArrow = nil;
    }else{
        if (self.lastArrow) {
            self.lastArrow.transform = CGAffineTransformIdentity;
        }
        [UIView animateWithDuration:0.25 animations:^{
            arrow.transform = CGAffineTransformRotate(arrow.transform, M_PI_2);
        }];
        self.lastArrow = arrow;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return self.photoViewHeight;
    }
    return 50;
}

@end
