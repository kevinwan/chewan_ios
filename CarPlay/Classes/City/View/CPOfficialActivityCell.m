//
//  CPOfficialActivityCell.m
//  CarPlay
//
//  Created by 公平价 on 15/8/17.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPOfficialActivityCell.h"

// 活动标题字体
#define ActiveTitleFont [UIFont systemFontOfSize:16]

// 活动截止时间字体
#define ActiveEndTimeFont [UIFont systemFontOfSize:12]

// 活动正文字体
#define ActiveContentFont [UIFont systemFontOfSize:14]

@interface CPOfficialActivityCell ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// 图片总数
@property (nonatomic,assign) NSInteger photoCount;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CPOfficialActivityCell

- (void)awakeFromNib {
    // Initialization code
    
}


+ (instancetype)officialActivityCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"CPOfficialActivityCell" owner:nil options:nil] lastObject];
}


- (void)setHomeStatus:(NSArray *)activeStatus{
    _activeStatus = activeStatus;
    
    // 设置图片总数
    self.photoCount = activeStatus.count;
    
    // 设置图片轮播器
    [self setPicPlay];
    
}

// 设置图片轮播器
- (void)setPicPlay{
    
    // 添加定时器(每隔2秒调用一次self 的nextImage方法)
    [self addTimer];
    
    // 0.一些固定的尺寸参数
    CGFloat imageW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    
    // 1.添加图片到scrollView中
    for (int i = 0; i<self.photoCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置图片显示格式
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        // 设置frame
        CGFloat imageX = i * imageW;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        // 设置图片
//        CPTaPhoto *taPhoto = self.taStatus.albumPhotos[i];
//        NSURL *url = [NSURL URLWithString:taPhoto.thumbnail_pic];
        
        
//        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        [self.scrollView addSubview:imageView];
    }
    
    // 2.设置内容尺寸
    CGFloat contentW = self.photoCount * imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 3.隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.分页
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    // 5.设置pageControl的总页数
//    self.pageControl.numberOfPages = self.photoCount;
    
    
    
}


- (void)setupSubviewFrameWithStatus:()status{
    
    // 活动标题
    UILabel *titleLabel = [[UILabel alloc] init];
    
    
    
    // 活动内容
    
    
    // 截止时间
    
    
    // 截止时间内容
    
    
    // 活动icon
    
    
    
    
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
//    if (self.pageControl.currentPage == self.photoCount - 1) {
//        page = 0;
//    } else {
//        page = (int)self.pageControl.currentPage + 1;
//    }
    
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
//    self.pageControl.currentPage = page;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
