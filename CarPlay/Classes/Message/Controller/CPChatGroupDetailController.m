//
//  CPChatGroupDetailController.m
//  CarPlay
//
//  Created by chewan on 15/8/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPChatGroupDetailController.h"
#import "CPIconButton.h"
#import "CPMoreButton.h"
#import "CPOrganizerButton.h"
#import "CPMySubscribeModel.h"
#import "UIButton+WebCache.h"
#import "CPTaDetailsController.h"
#import "CPMyController.h"

#define MaxMemberCount 9  // 最大显示的参与成员数

@interface CPChatGroupDetailController()

// 参与成员的photoView
@property (weak, nonatomic) IBOutlet UIView *memberPhotoView;

// 活动介绍的label
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

// 活动介绍cell的行高
@property (nonatomic, assign) CGFloat introduceCellHeight;

// 组织者的button
@property (weak, nonatomic) IBOutlet CPOrganizerButton *organizerButton;

// 活动组织者的箭头
@property (weak, nonatomic) IBOutlet UIImageView *organizerArrow;

// 是不是活动的组织者
@property (nonatomic, assign) BOOL isOrganizer;

// 组织者的userId
@property (nonatomic, copy) NSString *orzUserId;

@end

@implementation CPChatGroupDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"v1/activity/%@/info",self.activityId];
    NSString *userId = [Tools getValueFromKey:@"userId"];
    NSString *token = [Tools getValueFromKey:@"token"];
    [ZYNetWorkTool getWithUrl:url params:@{@"userId" : userId, @"token" : token} success:^(id responseObject) {
        [self disMiss];
        
        if (CPSuccess) {
            CPMySubscribeModel *model = [CPMySubscribeModel objectWithKeyValues:responseObject[@"data"]];
            self.isOrganizer = model.isOrganizer;
            self.introduceLabel.height = 50;
            self.introduceLabel.preferredMaxLayoutWidth = kScreenWidth - 20;
            CGFloat btnWH = 25;
            CGFloat maxX = 0;
            NSArray *members = model.members;
            CGFloat count = members.count > MaxMemberCount ? MaxMemberCount : members.count;
            
            // 清空之前所有的members
            [self.memberPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            for (int i = 0 ; i < count; i ++) {
                CPOrganizer *meb = members[i];
                CPIconButton *btn = [CPIconButton buttonWithType:UIButtonTypeCustom];
                btn.userInteractionEnabled = NO;
                [btn sd_setImageWithURL:[NSURL URLWithString:meb.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                btn.x = i * (btnWH + 5);
                btn.y = 0;
                btn.width = btnWH;
                btn.height = btnWH;
                [self.memberPhotoView addSubview:btn];
                maxX = (i + 1) * (btnWH + 5);
            }
            
            CPMoreButton *moreBtn = [CPMoreButton buttonWithType:UIButtonTypeCustom];
            [moreBtn setTitle:[NSString stringWithFormat:@"%zd",members.count] forState:UIControlStateNormal];
            moreBtn.userInteractionEnabled = NO;
            moreBtn.x = maxX;
            moreBtn.y = 0;
            moreBtn.width = btnWH;
            moreBtn.height = btnWH;
            [self.memberPhotoView addSubview:moreBtn];
            
            self.introduceLabel.text = model.introduction;
            CGFloat height = [self.introduceLabel.text sizeWithFont:self.introduceLabel.font maxW:kScreenWidth - 20].height;
            self.introduceLabel.height = height;
            
            self.introduceCellHeight = height + 62;
            
            // 设置组织者信息
            CPOrganizer *orz = model.organizer;
            if ([orz.userId isEqualToString:[Tools getValueFromKey:@"userId"]]) {
                self.organizerArrow.hidden = YES;
            }
            self.orzUserId = orz.userId;
            self.organizerButton.icon = orz.photo;
            self.organizerButton.name = orz.nickname;
            
            [self.tableView reloadData];

        }
       
    } failure:^(NSError *error) {
        [self showError:@"获取失败"];
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 87;
    }else if (indexPath.row == 1){
        if (self.introduceCellHeight){
            return self.introduceCellHeight;
        }
        return 50;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0 && self.activityId.length) {
        
        if (self.isOrganizer) { // 如果是组织者
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
            
            MembersManageController * vc = sb.instantiateInitialViewController;
            vc.activityId = self.activityId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{ // 如果只是成员
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
            
            MembersController * vc = sb.instantiateInitialViewController;
            vc.activityId = self.activityId;
            
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else if (indexPath.row == 2 && self.orzUserId.length){
        
        if ([self.orzUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
            return;
        }
        
        // 跳转到他的详情页
        CPTaDetailsController *taVc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
        taVc.targetUserId = self.orzUserId;
        [self.navigationController pushViewController:taVc animated:YES];
        
    }
}

@end
