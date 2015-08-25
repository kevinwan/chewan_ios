//
//  CPCPActiveDetailsHeader.m
//  CPActiveDetailsDemo
//
//  Created by 公平价 on 15/7/3.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActiveDetailsHead.h"
#import "CPActiveUser.h"
#import "CPActiveStatus.h"
#import "UIImageView+WebCache.h"
#import "CPActivePicCell.h"
#import "CPActiveIconCell.h"
#import "CPActiveMember.h"
#import "UIButton+WebCache.h"


@interface CPActiveDetailsHead()<UICollectionViewDataSource,UICollectionViewDelegate>

// 头像
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
- (IBAction)iconBtnClick:(id)sender;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *name;

// 性别和年龄
@property (weak, nonatomic) IBOutlet UIButton *genderAndAge;

// 汽车图标
@property (weak, nonatomic) IBOutlet UIImageView *carIcon;

// 状态
@property (weak, nonatomic) IBOutlet UILabel *status;

// 发布时间
@property (weak, nonatomic) IBOutlet UILabel *publishTime;

// 描述
@property (weak, nonatomic) IBOutlet UILabel *descriptions;

// 车型距离头像约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carModelConstraint;

// 开始时间
@property (weak, nonatomic) IBOutlet UILabel *startTime;

// 结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTime;

// 目的地
@property (weak, nonatomic) IBOutlet UILabel *location;

// 费用
@property (weak, nonatomic) IBOutlet UILabel *pay;

// 配图collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *picColView;

// 头像collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *iconColView;

// 配图容器的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewHeight;

// 配图容器的宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewWidth;

// 我要去玩
@property (weak, nonatomic) IBOutlet UIButton *myPlay;

// 底部view
@property (weak, nonatomic) IBOutlet UIView *bottomView;

// 座位数
@property (weak, nonatomic) IBOutlet UILabel *seating;

@end

@implementation CPActiveDetailsHead

+ (instancetype)headView:(id)owner{
    // xib路径
    return [[[NSBundle mainBundle] loadNibNamed:@"CPActiveDetailsHead" owner:owner options:nil] lastObject];
    
}

- (void)awakeFromNib{
    // 正文宽度
    self.descriptions.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
    
    // 目的地
    self.location.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width / 2 - 20;
    
    // 座位数
    self.seating.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
}

// 根据数据获取高度
- (CGFloat)xibHeightWithActiveStatus:(CPActiveStatus *)activeStatus{
    
    // 设置数据，便于系统内部计算尺寸
    self.activeStatus = activeStatus;
    
    // 强制更新布局
    [self layoutIfNeeded];
    
    // 获取高度
    if (iPhone5_JX) {
        return CGRectGetMaxY(self.bottomView.frame) + 50;
    }else{
        return CGRectGetMaxY(self.bottomView.frame);
    }
    
}


- (void)setActiveStatus:(CPActiveStatus *)activeStatus{
    
    // 注册collectionViewCell
    [self.iconColView registerClass:[CPActiveIconCell class] forCellWithReuseIdentifier:[CPActiveIconCell identifier]];
    [self.picColView registerClass:[CPActivePicCell class] forCellWithReuseIdentifier:[CPActivePicCell identifier]];
    
    _activeStatus = activeStatus;

    // 取出用户
    CPActiveUser *user = _activeStatus.organizer;
    
    // 头像
    self.iconBtn.layer.cornerRadius = 25;
    self.iconBtn.layer.masksToBounds = YES;
    NSURL *iconUrl = [NSURL URLWithString:user.photo];
    [self.iconBtn sd_setBackgroundImageWithURL:iconUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
 
    // 昵称
    self.name.text = user.nickname;
    
    // 年龄
    [self.genderAndAge setTitle:user.age forState:UIControlStateNormal];
    
    // 性别
    if ([user.gender isEqualToString:@"男"]) {
        [self.genderAndAge setBackgroundImage:[UIImage imageNamed:@"男-1"] forState:UIControlStateNormal];
    }else{
         [self.genderAndAge setBackgroundImage:[UIImage imageNamed:@"女-1"] forState:UIControlStateNormal];
    }
    
    
    // 汽车图标
    if (user.carBrandLogo == nil || [user.carBrandLogo isEqualToString:@""]) {
        self.carIcon.hidden = YES;
    }else{
        self.carIcon.hidden = NO;
        NSURL *urlCarBrandLogo = [NSURL URLWithString:user.carBrandLogo];
        [self.carIcon sd_setImageWithURL:urlCarBrandLogo placeholderImage:[UIImage imageNamed:@"imageplace"]];
        
    }
  
    
    // 状态
    NSString *tempCarModel = @"";     // 存储转换后的carModel
    NSString *tempDrivingExperience = @"";   // 存储转换后的drivingExperience
    
    if (user.carModel == nil || [user.carModel isEqualToString:@""])
    {}else{
        tempCarModel = user.carModel;
    }
    
    if ( [user.drivingExperience  isEqualToString:@"0"]|| user.drivingExperience == nil || [user.drivingExperience isEqualToString:@""]) {
        // 没有车的情况
        self.carModelConstraint.constant = 10;
        
        tempDrivingExperience = @"带我飞~";
        
    }else{
        //有车的情况
        if (user.carBrandLogo == nil || [user.carBrandLogo isEqualToString:@""]) {
            self.carModelConstraint.constant = 10;
        }else{
            self.carModelConstraint.constant = 31;
        }
        if (user.carModel == nil || [user.carModel isEqualToString:@""]) {
            tempDrivingExperience = [NSString stringWithFormat:@"%@年驾龄",user.drivingExperience];
            
        }else{
            tempDrivingExperience = [NSString stringWithFormat:@",%@年驾龄",user.drivingExperience];
        }
    }
    
    NSString *states = [NSString stringWithFormat:@"%@%@",tempCarModel,tempDrivingExperience];
    self.status.text = states;
    
    
    // 我要去玩按钮
    self.myPlay.layer.cornerRadius = 12;
    self.myPlay.layer.masksToBounds = YES;
    
    [self.myPlay setBackgroundColor:[Tools getColor:@"fc6e51"]];
    if (activeStatus.isOrganizer) {
        [self.myPlay setTitle:@"成员管理" forState:UIControlStateNormal];
    }else if (activeStatus.isMember){
        if (activeStatus.isMember == 1) {
            [self.myPlay setTitle:@"已加入" forState:UIControlStateNormal];
        }else if (activeStatus.isMember == 2){
            [self.myPlay setTitle:@"申请中" forState:UIControlStateNormal];
            [self.myPlay setBackgroundColor:[Tools getColor:@"ccd1d9"]];
        }
        
    }else{
        [self.myPlay setTitle:@"我要去玩" forState:UIControlStateNormal];
    }
 
    
    // 发布时间
    self.publishTime.text = _activeStatus.publishTimeStr;
    
    // 描述
    self.descriptions.text = _activeStatus.introduction;

    // 开始时间
    self.startTime.text = _activeStatus.startStr;
    
    // 结束时间
    self.endTime.text = _activeStatus.endStr;
    
    // 目的地
    self.location.text = _activeStatus.location;
    
    // 费用
    self.pay.text = _activeStatus.pay;
    
    // 座位数
    self.seating.text = _activeStatus.seatInfo;
    
    // 计算配图宽高
    CGSize pictureViewSize = [self caclPictureViewSize];
    self.pictureViewHeight.constant = pictureViewSize.height;
    self.pictureViewWidth.constant = pictureViewSize.width;
    
}

// 计算配图宽高
- (CGSize)caclPictureViewSize{
    // 配图的总个数
    NSInteger count = self.activeStatus.cover.count;
    
    // 处理没有配图的情况
    if (count == 0) {
        return CGSizeZero;
    }
    
    // 计算行数列数
    NSInteger maxcols = count == 4 ? 2 : 3;
    NSInteger col = count > 3 ? maxcols : count;
    NSInteger row = 1;
    if (count % 3 == 0) {
        row = count / 3;
    }else{
        row = count / 3 + 1;
    }
    
    // 计算宽高
    CGFloat pictureH = 78;
    CGFloat pictureW = 78;
    CGFloat pictureM = 3;  //间隙
    // 宽度 = 列数 * 配图宽度 +（列数 - 1）* 间隙
    CGFloat pictureViewW = col * pictureW + (col - 1) * pictureM;
    // 高度 = 行数 * 配图高度 +（行数 - 1）* 间隙
    CGFloat pictureViewH = row * pictureH + (row - 1) * pictureM;
    
    
    return CGSizeMake(pictureViewW, pictureViewH);
}


#pragma mark - collectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    // 图片个数
    if (collectionView == self.picColView) {
        return self.activeStatus.cover.count;
    }else{
        return self.activeStatus.members.count;
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (collectionView == self.picColView) {
        // 创建cell
        CPActivePicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CPActivePicCell identifier] forIndexPath:indexPath];
        
        // 给cell赋值
        cell.activePhoto = self.activeStatus.cover[indexPath.item];
        
        return cell;
    }else{
        // 创建cell
        CPActiveIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CPActiveIconCell identifier] forIndexPath:indexPath];
        
        // 获取对应图片模型
        CPActiveMember *photo = self.activeStatus.members[indexPath.item];
//        photo.membersCount = self.activeStatus.members.count;
        photo.currentMember = indexPath.item;
        
        // 设置数据
        cell.activeMember = photo;
        
        return cell;
    }
    
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.picColView) {
        if (self.pictureDidSelected != nil) {
            // 获取每一个cell里的所有配图
            NSMutableArray *imgArr = [NSMutableArray array];
            NSUInteger count = [self collectionView:collectionView numberOfItemsInSection:0];
            
            for (int i = 0; i < count; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                
                CPActivePicCell *cell = (CPActivePicCell *)[self collectionView:collectionView cellForItemAtIndexPath:path];
                cell.pictureView.frame = cell.frame;
                [imgArr addObject:cell.pictureView];
            }
            
            
            self.pictureDidSelected(self.activeStatus,indexPath, imgArr);
        }
    }
    
}




// 点击头像跳转到他的详情页
- (IBAction)iconBtnClick:(id)sender {
    // 判断是否已登录
    if (!CPUnLogin) {
        
         // 已登录通知控制器跳到他的详情页面
        if (self.goTaDetails != nil) {
            self.goTaDetails();
        }
    }else{
        
        // 未登录跳到登录页面
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
    }
    
}

// headview点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self routerEventWithName:@"" userInfo:nil];
}

@end
