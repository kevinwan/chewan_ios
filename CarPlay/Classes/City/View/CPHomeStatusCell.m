//
//  CPHomeStatusCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHomeStatusCell.h"
#import "UIImageView+WebCache.h"
#import "CPHomeUser.h"
#import "CPHomeStatus.h"
#import "CPHomePicCell.h"
#import "CPHomeIconCell.h"
#import "CPHomePhoto.h"
#import "CPHomeMember.h"
#import "UIResponder+Router.h"



@interface CPHomeStatusCell()<UICollectionViewDataSource,UICollectionViewDelegate>


// 头像
@property (weak, nonatomic) IBOutlet UIImageView *photo;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickname;

// 性别和年龄
@property (weak, nonatomic) IBOutlet UIButton *genderAndAge;


// 车标
@property (weak, nonatomic) IBOutlet UIImageView *carBrandLogo;

// 状态描述
@property (weak, nonatomic) IBOutlet UILabel *states;

// 发布时间
@property (weak, nonatomic) IBOutlet UILabel *publishTime;

// 付费方式
@property (weak, nonatomic) IBOutlet UILabel *pay;

// 付费方式View
@property (weak, nonatomic) IBOutlet UIView *payView;

// 已占座位
@property (weak, nonatomic) IBOutlet UILabel *holdingSeat;

// 总座
@property (weak, nonatomic) IBOutlet UILabel *totalSeat;

// 已占座位距左约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holdingSeatConstraint;

// 正文
@property (weak, nonatomic) IBOutlet UILabel *introduction;

// 活动时间
@property (weak, nonatomic) IBOutlet UILabel *start;

// 地点
@property (weak, nonatomic) IBOutlet UILabel *loction;

// 配图容器的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewHeight;

// 配图容器的宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewWidth;

// 车标到头像距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carModelConstraint;

// 底部头像列表框
@property (weak, nonatomic) IBOutlet UIView *bottomIconList;

// 配图collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *pictureView;

// 昵称距离顶部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nicknameConstraint;

// 发布时间距离顶部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishTimeConstraint;


@end

@implementation CPHomeStatusCell

- (void)awakeFromNib {
    
    // 设置正文最大的宽度
    self.introduction.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 75;
    
    // 头像添加单击手势
    self.photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
    [self.photo addGestureRecognizer:tap];
}


+ (NSString *)identifier{
    return @"CPHomeCell";
}


- (void)setStatus:(CPHomeStatus *)status{
    
//    if ([status isKindOfClass:[NSArray class]]) {
//        return;
//    }
    
    _status = status;
    
    CPHomeUser *user = _status.organizer;
    
    // 头像
    // 头像切圆
    self.photo.layer.cornerRadius = 25;
    self.photo.layer.masksToBounds = YES;
    NSURL *urlPhoto = [NSURL URLWithString:user.photo];
    [self.photo sd_setImageWithURL:urlPhoto placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    
    
    
    // 我要去玩
    self.myPlay.layer.cornerRadius = 12;
    self.myPlay.layer.masksToBounds = YES;
    
    [self.myPlay setBackgroundColor:[Tools getColor:@"fc6e51"]];
    
    
    if (self.status.isOrganizer) {
        [self.myPlay setTitle:@"成员管理" forState:UIControlStateNormal];
    }else if (self.status.isMember){
        if (self.status.isMember == 1) {
            [self.myPlay setTitle:@"已加入" forState:UIControlStateNormal];
        }else if(self.status.isMember == 2){
            [self.myPlay setTitle:@"申请中" forState:UIControlStateNormal];
            [self.myPlay setBackgroundColor:[Tools getColor:@"ccd1d9"]];  
        }
        
    }else{
        [self.myPlay setTitle:@"我要去玩" forState:UIControlStateNormal];
    }
    
    if (self.status.isOver) {
        [self.myPlay setTitle:@"已结束" forState:UIControlStateNormal];
        [self.myPlay setBackgroundColor:[Tools getColor:@"ccd1d9"]];
        self.myPlay.userInteractionEnabled = NO;
    }
    
    // 昵称
    self.nickname.text = user.nickname;
    
    // 年龄
    [self.genderAndAge setTitle:user.age forState:UIControlStateNormal];
    

    // 性别
    if ([user.gender isEqualToString:@"男"]) {
        [self.genderAndAge setBackgroundImage:[UIImage imageNamed:@"男-1"] forState:UIControlStateNormal];
    }else{
        [self.genderAndAge setBackgroundImage:[UIImage imageNamed:@"女-1"] forState:UIControlStateNormal];
    }
    
    // 车标
    if (user.carBrandLogo == nil || [user.carBrandLogo isEqualToString:@""]) {
        
        self.carBrandLogo.hidden = YES;
    }else{
        self.carBrandLogo.hidden = NO;
        NSURL *urlCarBrandLogo = [NSURL URLWithString:user.carBrandLogo];
        [self.carBrandLogo sd_setImageWithURL:urlCarBrandLogo placeholderImage:[UIImage imageNamed:@"imageplace"]];
        
    }
    
   
    // 状态描述
    NSString *tempCarModel = @"";     // 存储转换后的carModel
    NSString *tempDrivingExperience = @"";   // 存储转换后的drivingExperience


    
    // 车型是否为空
    if (user.carModel == nil || [user.carModel isEqualToString:@""])
    {}else{
        tempCarModel = user.carModel;
    }
    
    // 驾龄是否为空
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
    self.states.text = states;
    
    // 发布时间
    self.publishTime.text = _status.publishTimeStr;
    
    // 活动时间
    self.start.text = _status.startStr;
    
    // 活动地点
//    if ([status.location length]>5) {
//        NSString *tempLocation = [_status.location substringToIndex:6];
//        self.loction.text = [NSString stringWithFormat:@"%@...",tempLocation];
//    }else{
//        self.loction.text = status.location;
//    }
    self.loction.text = status.location;
    
    
    // 付费方式
    self.pay.text = _status.pay;
    
    // 付费方式View
    self.payView.layer.cornerRadius = 2;
    self.payView.clipsToBounds = YES;
    if ([_status.pay isEqualToString:@"AA制"]) {
        // AA制
        self.payView.backgroundColor = [Tools getColor:@"48d1d5"];
    }else if([_status.pay isEqualToString:@"我请客"]){
        // 我请客
        self.payView.backgroundColor = [Tools getColor:@"fc6e51"];
    }else{
        // 请我吧
        self.payView.backgroundColor = [Tools getColor:@"ccd1d9"];
    }
    
    
    // 座位已满情况
    if ([_status.holdingSeat isEqualToString:_status.totalSeat]) {
        self.holdingSeatConstraint.constant = 24;
        self.holdingSeat.text = @"已满";
        self.totalSeat.text = @"";
        
    }else{
        // 座位不满的情况
        // 余座
        if (_status.holdingSeat == nil || [_status.holdingSeat isEqualToString:@""]) {
            self.holdingSeat.text = @"";
        }else{
            self.holdingSeat.text = _status.holdingSeat;
        }
        
        // 总座
        if (_status.totalSeat == nil || [_status.totalSeat isEqualToString:@""]) {
            self.totalSeat.text = @"";
        }else{
            NSString *totalSeatStr = [NSString stringWithFormat:@"/%@座",_status.totalSeat];
            self.totalSeat.text = totalSeatStr;
        }
    }
     
    
    // 正文
    self.introduction.text = _status.introduction;
    
    
    // 计算配图宽高
    CGSize pictureViewSize = [self caclPictureViewSize];
    self.pictureViewHeight.constant = pictureViewSize.height;
    self.pictureViewWidth.constant = pictureViewSize.width;
    
    
    // 是否为官方活动
    if ([status.organizer.role isEqualToString:@"官方用户"]) {
        self.genderAndAge.hidden = YES;
        self.carBrandLogo.hidden = YES;
        self.states.hidden = YES;
        self.nicknameConstraint.constant = 33;
        self.publishTimeConstraint.constant = 35;
    }
    
    
    // 刷新，collectionView数据清零
    [self.pictureView reloadData];
    [self.iconView reloadData];
    
    
}


//  头像点击
- (void)imageClick:(UITapGestureRecognizer *)sender{

    // 已登录通知控制器跳到他的详情页面
    [self routerEventWithName:@"IconClick" userInfo:@{@"status" : self.status}];
}


// 计算配图宽高
- (CGSize)caclPictureViewSize{
    // 配图的总个数
    NSInteger count = self.status.cover.count;
    
    // 处理没有配图的情况
    if (count == 0) {
        return CGSizeZero;
    }
    if (count == 1) {
        return CGSizeMake(159, 107);
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
    if (collectionView == self.pictureView) {
        // 返回配图个数
        return self.status.cover.count;
    }else
    {
        return self.status.membersCount;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.pictureView) {
        // 创建cell
        CPHomePicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CPHomePicCell identifier] forIndexPath:indexPath];
        
        // 特殊处理有一张图片的情况
        if (self.status.cover.count == 1) {
            CGRect temp = cell.frame;
            temp = CGRectMake(0, 0, 159, 107);
            cell.frame = temp;
        }
        if (self.status.cover.count > 1 && indexPath.item == 0) {
            CGRect temp = cell.frame;
            temp = CGRectMake(0, 0, 78, 78);
            cell.frame = temp;
        }
        

        
        // 获取对应图片模型
        CPHomePhoto *photo = self.status.cover[indexPath.item];
        
        // 设置数据
        cell.homePhoto = photo;
        
        
        // 返回cell
        return cell;
    }else{
        // 创建cell
        CPHomeIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CPHomeIconCell identifier] forIndexPath:indexPath];
        
        // 获取对应图片模型
        CPHomeMember *member = self.status.members[indexPath.item];
        
//        if (self.status.members.count == indexPath.item + 1) {
//            member.currentMember = indexPath.item;
//        }
        
        // 设置数据
        cell.homeMember = member;
        
        // 返回cell
        return cell;
    }
    
    
}


// 点击配图放大
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    if (collectionView == self.pictureView) {
        
        
        if (self.pictureDidSelected != nil) {
            // 获取每一个cell里的所有配图
            NSMutableArray *imgArr = [NSMutableArray array];
            NSUInteger count = [self collectionView:collectionView numberOfItemsInSection:0];
            
            for (int i = 0; i < count; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                
                CPHomePicCell *cell = (CPHomePicCell *)[self collectionView:collectionView cellForItemAtIndexPath:path];
                cell.pictureView.frame = cell.frame;
                [imgArr addObject:cell.pictureView];
            }

            

            self.pictureDidSelected(self.status,indexPath, imgArr);
        }
    } else {
        if (self.tapIcons != nil) {
            self.tapIcons(self.status);
        }
    }
}


#pragma mark - 外部方法

- (CGFloat)cellHeightWithStatus:(CPHomeStatus *)status{
    
    // 设置数据，便于系统内部计算尺寸
    self.status = status;
    
    // 强制更新布局
    [self layoutIfNeeded];
    
    // 返回cell高度，cell的高度就是底部头像列表的最大高度
    return CGRectGetMaxY(self.bottomIconList.frame) + 15;
    
}



@end
