//
//  CPTaDetailsHead.m
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//



#import "CPTaDetailsHead.h"
#import "UIImageView+WebCache.h"
#import "CPTaPhoto.h"

@interface CPTaDetailsHead ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *photo;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickname;

// 性别和年龄
@property (weak, nonatomic) IBOutlet UIButton *genderAndAge;

// 关注
@property (weak, nonatomic) IBOutlet UIButton *care;

// 车标
@property (weak, nonatomic) IBOutlet UIImageView *carBrandLogo;

// 状态
@property (weak, nonatomic) IBOutlet UILabel *state;

// 他的发布
@property (weak, nonatomic) IBOutlet UIButton *taPublish;

// 他的关注
@property (weak, nonatomic) IBOutlet UIButton *taCare;

// 他的参与
@property (weak, nonatomic) IBOutlet UIButton *taJoin;

// 发布线
@property (weak, nonatomic) IBOutlet UIView *publishLine;

// 关注线
@property (weak, nonatomic) IBOutlet UIView *careLine;

// 参与线
@property (weak, nonatomic) IBOutlet UIView *joinLine;

// 车型到头像约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carModelConstraint;

// 发布底部
@property (weak, nonatomic) IBOutlet UIView *publishView;

// 关注底部
@property (weak, nonatomic) IBOutlet UIView *careView;

// 参与底部
@property (weak, nonatomic) IBOutlet UIView *joinView;

// TA的发布按钮约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taPublishConstraint;

// TA的关注按钮约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taCareConstraint;

// TA的参与按钮约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taJoinConstraint;

- (IBAction)taPublishClick:(id)sender;

- (IBAction)taCareClick:(id)sender;

- (IBAction)taJoinClick:(id)sender;


// 图片总数
@property (nonatomic,assign) NSInteger photoCount;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CPTaDetailsHead


+ (instancetype)headView{
    // xib路径
    return [[[NSBundle mainBundle] loadNibNamed:@"CPTaDetailsHead" owner:nil options:nil] lastObject];
    
}

- (void)setTaStatus:(CPTaDetailsStatus *)taStatus{
    _taStatus = taStatus;
    
    // 取出图片总数
    self.photoCount = taStatus.albumPhotos.count;
    // 设置图片轮播器
    [self setPicPlay];
    
    // 设置头像
    self.photo.layer.cornerRadius = 25;
    self.photo.layer.masksToBounds = YES;
    NSURL *photoUrl = [NSURL URLWithString:taStatus.photo];
    [self.photo sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
    // 设置昵称
    self.nickname.text = taStatus.nickname;
    
    // 设置性别
    if ([taStatus.gender isEqualToString:@"男"]) {
        [self.genderAndAge setBackgroundImage:[UIImage imageNamed:@"男-1"] forState:UIControlStateNormal];
    }else{
        [self.genderAndAge setBackgroundImage:[UIImage imageNamed:@"女-1"] forState:UIControlStateNormal];
    }
    
    // 设置年龄
    [self.genderAndAge setTitle:taStatus.age forState:UIControlStateNormal];
    
    // 设置车标
    NSURL *carIconUrl = [NSURL URLWithString:taStatus.carBrandLogo];
    [self.carBrandLogo sd_setImageWithURL:carIconUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    // 设置状态
    NSString *tempCarModel = @"";     // 存储转换后的carModel
    NSString *tempDrivingExperience = @"";   // 存储转换后的drivingExperience
    
    if (taStatus.carModel == nil || [taStatus.carModel isEqualToString:@""])
    {}else{
        tempCarModel = taStatus.carModel;
    }
    
    if ( [taStatus.drivingExperience  isEqualToString:@"0"]|| taStatus.drivingExperience == nil || [taStatus.drivingExperience isEqualToString:@""]) {
        // 没有车的情况
        self.carModelConstraint.constant = 10;
        tempDrivingExperience = @"带我飞~";
        
    }else{
        //有车的情况
        self.carModelConstraint.constant = 38;
        if (taStatus.carModel == nil || [taStatus.carModel isEqualToString:@""]) {
            tempDrivingExperience = [NSString stringWithFormat:@"%@年驾龄",taStatus.drivingExperience];
            
        }else{
            tempDrivingExperience = [NSString stringWithFormat:@",%@年驾龄",taStatus.drivingExperience];
        }
    }
    
    NSString *states = [NSString stringWithFormat:@"%@%@",tempCarModel,tempDrivingExperience];
    self.state.text = states;
    
    // 设置关注
    self.care.layer.cornerRadius = 15;
    self.care.layer.masksToBounds = YES;
    
    // 设置发布
    [self setPublishBtn:[UIColor redColor]];
    
    // 设置关注
    [self setCareBtn:[UIColor grayColor]];
    
    // 设置参与
    [self setJoinBtn:[UIColor grayColor]];
    
    
}

// 设置发布按钮
- (void)setPublishBtn:(UIColor *)color{
    // 1.设置按钮文字居中、显示多行文字
    self.taPublish.titleLabel.textAlignment = NSTextAlignmentCenter; // 文字居中
    self.taPublish.titleLabel.numberOfLines = 0; // 显示多行文字
    
    // 2.设置发布数量的字体大小、颜色
    NSDictionary *dictAttP1 = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:color}; // 属性字典
    if(!self.taStatus.postNumber){
        self.taStatus.postNumber = @"0";
    }
    
    NSMutableAttributedString *publishAttStr = [[NSMutableAttributedString alloc] initWithString:[self.taStatus.postNumber stringByAppendingString:@"\n"]attributes:dictAttP1];
    
    // 3.设置TA的发布的大小、颜色
    NSDictionary *dictAttP2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:color};
    NSAttributedString *publishAttStr1 = [[NSAttributedString alloc] initWithString:@"TA的发布" attributes:dictAttP2];
    
    // 4.拼接字符串
    [publishAttStr appendAttributedString:publishAttStr1];
    
    // 5.设置文字
    [self.taPublish setAttributedTitle:publishAttStr forState:UIControlStateNormal];
    
}

// 设置关注按钮
- (void)setCareBtn:(UIColor *)color{
    // 1.设置按钮文字居中、显示多行文字
    self.taCare.titleLabel.textAlignment = NSTextAlignmentCenter; // 文字居中
    self.taCare.titleLabel.numberOfLines = 0; // 显示多行文字
    
    // 2.设置发布数量的字体大小、颜色
    NSDictionary *dictAttC1 = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:color}; // 属性字典
    
    if (!self.taStatus.subscribeNumber) {
        self.taStatus.subscribeNumber = @"0";
    }
    
    NSMutableAttributedString *careAttStr = [[NSMutableAttributedString alloc] initWithString:[self.taStatus.subscribeNumber stringByAppendingString:@"\n"]attributes:dictAttC1];
    
    // 3.设置TA的发布的大小、颜色
    NSDictionary *dictAttC2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:color};
    NSAttributedString *careAttStr1 = [[NSAttributedString alloc] initWithString:@"TA的关注" attributes:dictAttC2];
    
    // 4.拼接字符串
    [careAttStr appendAttributedString:careAttStr1];
    
    // 5.设置文字
    [self.taCare setAttributedTitle:careAttStr forState:UIControlStateNormal];
}

// 设置参与按钮
- (void)setJoinBtn:(UIColor *)color{
    // 1.设置按钮文字居中、显示多行文字
    self.taJoin.titleLabel.textAlignment = NSTextAlignmentCenter; // 文字居中
    self.taJoin.titleLabel.numberOfLines = 0; // 显示多行文字
    
    // 2.设置发布数量的字体大小、颜色
    NSDictionary *dictAttJ1 = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:color}; // 属性字典
    
    if (!self.taStatus.joinNumber) {
        self.taStatus.joinNumber = @"0";
    }
    
    NSMutableAttributedString *joinAttStr = [[NSMutableAttributedString alloc] initWithString:[self.taStatus.joinNumber stringByAppendingString:@"\n"]attributes:dictAttJ1];
    
    // 3.设置TA的发布的大小、颜色
    NSDictionary *dictAttJ2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:color};
    NSAttributedString *joinAttStr1 = [[NSAttributedString alloc] initWithString:@"TA的参与" attributes:dictAttJ2];
    
    // 4.拼接字符串
    [joinAttStr appendAttributedString:joinAttStr1];
    
    // 5.设置文字
    [self.taJoin setAttributedTitle:joinAttStr forState:UIControlStateNormal];
}


// 设置图片轮播器
- (void)setPicPlay{
    // 0.一些固定的尺寸参数
    CGFloat imageW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    
    // 1.添加5张图片到scrollView中
    for (int i = 0; i<self.photoCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置frame
        CGFloat imageX = i * imageW;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        // 设置图片
        CPTaPhoto *taPhoto = self.taStatus.albumPhotos[i];
        NSURL *url = [NSURL URLWithString:taPhoto.thumbnail_pic];
        
        
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        [self.scrollView addSubview:imageView];
    }
    
    // 2.设置内容尺寸
    CGFloat contentW = self.photoCount * imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 3.隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.分页
    self.scrollView.pagingEnabled = YES;
    //    self.scrollView.delegate = self;
    
    // 5.设置pageControl的总页数
    self.pageControl.numberOfPages = self.photoCount;
    
    // 6.添加定时器(每隔2秒调用一次self 的nextImage方法)
    [self addTimer];
}



/**
 *  添加定时器
 */
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage
{
    // 1.增加pageControl的页码
    int page = 0;
    if (self.pageControl.currentPage == self.photoCount - 1) {
        page = 0;
    } else {
        page = (int)self.pageControl.currentPage + 1;
    }
    
    // 2.计算scrollView滚动的位置
    CGFloat offsetX = page * self.scrollView.frame.size.width;
    CGPoint offset = CGPointMake(offsetX,0);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 代理方法
/**
 *  当scrollView正在滚动就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据scrollView的滚动位置决定pageControl显示第几页
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.pageControl.currentPage = page;
}

/**
 *  开始拖拽的时候调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止定时器(一旦定时器停止了,就不能再使用)
    [self removeTimer];
}

/**
 *  停止拖拽的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 开启定时器
    [self addTimer];
}


- (IBAction)taPublishClick:(id)sender {
    // 设置底部线颜色
    self.publishView.backgroundColor = [UIColor redColor];
    self.careView.backgroundColor = [UIColor grayColor];
    self.joinView.backgroundColor = [UIColor grayColor];
    
    // 设置约束
    self.taPublishConstraint.constant = 2;
    self.taCareConstraint.constant = 5;
    self.taJoinConstraint.constant = 5;
    
    // 设置文字颜色
    [self setPublishBtn:[UIColor redColor]];
    [self setCareBtn:[UIColor grayColor]];
    [self setJoinBtn:[UIColor grayColor]];
}

- (IBAction)taCareClick:(id)sender {
    // 设置底部线颜色
    self.publishView.backgroundColor = [UIColor grayColor];
    self.careView.backgroundColor = [UIColor redColor];
    self.joinView.backgroundColor = [UIColor grayColor];
    
    self.taPublishConstraint.constant = 5;
    self.taCareConstraint.constant = 2;
    self.taJoinConstraint.constant = 5;
    
    // 设置文字颜色
    [self setPublishBtn:[UIColor grayColor]];
    [self setCareBtn:[UIColor redColor]];
    [self setJoinBtn:[UIColor grayColor]];
    
}

- (IBAction)taJoinClick:(id)sender {
    // 设置底部线颜色
    self.publishView.backgroundColor = [UIColor grayColor];
    self.careView.backgroundColor = [UIColor grayColor];
    self.joinView.backgroundColor = [UIColor redColor];
    
    // 设置约束
    self.taPublishConstraint.constant = 5;
    self.taCareConstraint.constant = 5;
    self.taJoinConstraint.constant = 2;
    
    // 设置文字颜色
    [self setPublishBtn:[UIColor grayColor]];
    [self setCareBtn:[UIColor grayColor]];
    [self setJoinBtn:[UIColor redColor]];

    
}
@end
