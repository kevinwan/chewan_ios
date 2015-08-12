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



@end

@implementation CPHomeStatusCell

- (void)awakeFromNib {
    
    // 设置正文最大的宽度
    self.introduction.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 75;
}


+ (NSString *)identifier{
    return @"CPHomeCell";
}


- (void)setStatus:(CPHomeStatus *)status{
    
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
    
    if (self.status.isOrganizer) {
        [self.myPlay setTitle:@"成员管理" forState:UIControlStateNormal];
    }else if (self.status.isMember){
        [self.myPlay setTitle:@"已加入" forState:UIControlStateNormal];
    }else{
        [self.myPlay setTitle:@"我要去玩" forState:UIControlStateNormal];
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
        [self.carBrandLogo sd_setImageWithURL:urlCarBrandLogo placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        
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
    if ([status.location length]>5) {
        NSString *tempLocation = [_status.location substringToIndex:5];
        self.loction.text = [NSString stringWithFormat:@"%@...",tempLocation];
    }else{
        self.loction.text = status.location;
    }
    
    
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
    
    
    
    // 余座
    if (_status.holdingSeat == nil || [_status.holdingSeat isEqualToString:@""]) {
        self.holdingSeat.text = @"";
    }else{
        self.holdingSeat.text = _status.holdingSeat;
    }
//    self.holdingSeat.text = @"已";

    
    // 总座
    if (_status.totalSeat == nil || [_status.totalSeat isEqualToString:@""]) {
        self.totalSeat.text = @"";
    }else{
        NSString *totalSeatStr = [NSString stringWithFormat:@"/%@座",_status.totalSeat];
        self.totalSeat.text = totalSeatStr;
    }
//    self.totalSeat.text = @"满";
    
    
    // 正文
    self.introduction.text = _status.introduction;
    
    
    
    // 头像列表
    [self.bottomIconList setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"头像列表背景"]]];
    
    
    // 计算配图宽高
    CGSize pictureViewSize = [self caclPictureViewSize];
    self.pictureViewHeight.constant = pictureViewSize.height;
    self.pictureViewWidth.constant = pictureViewSize.width;
    
    
    // 刷新，collectionView数据清零
    [self.pictureView reloadData];
    [self.iconView reloadData];
    
}

// 计算配图宽高
- (CGSize)caclPictureViewSize{
    // 配图的总个数
    NSInteger count = self.status.cover.count;
    
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
    if (collectionView == self.pictureView) {
        // 返回配图个数
        return self.status.cover.count;
    }else
    {
        return self.status.members.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.pictureView) {
        // 创建cell
        CPHomePicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CPHomePicCell identifier] forIndexPath:indexPath];
        
        // 获取对应图片模型
        CPHomePhoto *photo = self.status.cover[indexPath.item];
        
        // 设置数据
        cell.homePhoto = photo;
        
//        NSLog(@"%@",cell.pictureView.frameStr);
        
        // 返回cell
        return cell;
    }else{
        // 创建cell
        CPHomeIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CPHomeIconCell identifier] forIndexPath:indexPath];
        
        // 获取对应图片模型
        CPHomeMember *photo = self.status.members[indexPath.item];
        photo.membersCount = self.status.members.count;
        photo.currentMember = indexPath.item;
        
        // 设置数据
        cell.homeMember = photo;
        
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
