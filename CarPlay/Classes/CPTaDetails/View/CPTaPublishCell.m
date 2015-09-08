//
//  CPTaPublishCell.m
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaPublishCell.h"
#import "CPTaPicCell.h"
#import "CPTaIconCell.h"

@interface CPTaPublishCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
// 发布时间
@property (weak, nonatomic) IBOutlet UILabel *publishDate;

// 时间点
@property (weak, nonatomic) IBOutlet UIView *timePoint;

// 正文
@property (weak, nonatomic) IBOutlet UILabel *introduction;

// 顶部时间线
@property (weak, nonatomic) IBOutlet UIView *topTimeLine;

// 开始时间
@property (weak, nonatomic) IBOutlet UILabel *startDate;

// 地点
@property (weak, nonatomic) IBOutlet UILabel *location;

// 付费方式
@property (weak, nonatomic) IBOutlet UILabel *pay;

// 配图列表
@property (weak, nonatomic) IBOutlet UICollectionView *picColView;

// 头像列表
@property (weak, nonatomic) IBOutlet UICollectionView *iconColView;

// 配图容器高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewHeight;

// 配图容器宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewWidth;

// 底部头像列表框
@property (weak, nonatomic) IBOutlet UIView *bottomIconList;




@end

@implementation CPTaPublishCell

- (void)awakeFromNib {
    
    self.picColView.scrollsToTop = NO;
    self.iconColView.scrollsToTop = NO;
    
    // 设置正文的宽度
    self.introduction.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 78;
}

+ (NSString *)identifier{
    return @"taPublishCell";
}

- (void)setPublishStatus:(CPTaPublishStatus *)publishStatus{
    _publishStatus = publishStatus;
    
    // 发布时间
    self.publishDate.text = publishStatus.publishDate;
    
    // 我要去玩
    self.myPlay.layer.cornerRadius = 12.5;
    self.myPlay.layer.masksToBounds = YES;
    
    [self.myPlay setBackgroundColor:[Tools getColor:@"fc6e51"]];
    if (publishStatus.isOrganizer) {
        [self.myPlay setTitle:@"成员管理" forState:UIControlStateNormal];
    }else if (publishStatus.isMember){
        if (publishStatus.isMember == 1) {
            [self.myPlay setTitle:@"已加入" forState:UIControlStateNormal];
        }else if (publishStatus.isMember == 2){
            [self.myPlay setTitle:@"申请中" forState:UIControlStateNormal];
            [self.myPlay setBackgroundColor:[Tools getColor:@"ccd1d9"]];
        }
        
    }else{
        [self.myPlay setTitle:@"我要去玩" forState:UIControlStateNormal];
    }
    
    
    // 时间点
    // 切圆
    self.timePoint.layer.cornerRadius = 2.5;
    self.timePoint.layer.masksToBounds = YES;
    
    // 正文
    self.introduction.text = publishStatus.introduction;
    
    // 头像列表
    [self.bottomIconList setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"头像列表背景"]]];
    
    // 开始时间
    self.startDate.text = publishStatus.startDateStr;
    
    // 地点
    self.location.text = publishStatus.location;
    
    // 付费方式
    self.pay.text = publishStatus.pay;
    
    // 顶部时间线
    if (self.isFirst) {
        self.topTimeLine.hidden = YES;
    }else{
        self.topTimeLine.hidden = NO;
    }
    
    
    // 计算配图宽高
    CGSize pictureViewSize = [self caclPictureViewSize];
    self.pictureViewHeight.constant = pictureViewSize.height;
    self.pictureViewWidth.constant = pictureViewSize.width;
    
    
    // 刷新，collectionView数据清零
    [self.picColView reloadData];
    [self.iconColView reloadData];
    


}

// 计算配图宽高
- (CGSize)caclPictureViewSize{
    // 配图的总个数
    NSInteger count = self.publishStatus.cover.count;
    
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
    
    if (collectionView == self.picColView) {
        return self.publishStatus.cover.count;
    }else{
        return self.publishStatus.membersCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.picColView) {
        // 创建cell
        CPTaPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CPTaPicCell identifier] forIndexPath:indexPath];
        
        // 赋值
        cell.taPhoto = self.publishStatus.cover[indexPath.item];
        return cell;
    }else{
        CPTaIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CPTaIconCell identifier] forIndexPath:indexPath];
        cell.taMember = self.publishStatus.members[indexPath.item];
//        NSLog(@"对象%@---个数%ld",cell.taMember,indexPath.item);
        return cell;
    } 
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.picColView) {
        if (self.taPictureDidSelected != nil) {
            // 获取每一个cell里的所有配图
            NSMutableArray *imgArr = [NSMutableArray array];
            NSUInteger count = [self collectionView:collectionView numberOfItemsInSection:0];
            
            for (int i = 0; i < count; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                
                CPTaPicCell *cell = (CPTaPicCell *)[self collectionView:collectionView cellForItemAtIndexPath:path];
                cell.pictureView.frame = cell.frame;
                [imgArr addObject:cell.pictureView];
            }
                 
            
            self.taPictureDidSelected(self.publishStatus,indexPath, imgArr);
        }
    } else {
        if (self.tapIcons != nil) {
            self.tapIcons(self.publishStatus);
        }
    }
}

// 计算cell高度
- (CGFloat)cellHeightWithTaPublishStatus:(CPTaPublishStatus *)publishStatus{
    
    // 设置数据
    self.publishStatus = publishStatus;
    
    // 强制更新布局
    [self layoutIfNeeded];
    
    // 返回cell高度，就是底部view的最大高度
    return CGRectGetMaxY(self.bottomIconList.frame) + 10;
}




@end
