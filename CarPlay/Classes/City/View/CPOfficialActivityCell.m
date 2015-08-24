//
//  CPOfficialActivityCell.m
//  CarPlay
//
//  Created by 公平价 on 15/8/17.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPOfficialActivityCell.h"
#import "CPOfficialActivity.h"

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

// 记录当前页
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation CPOfficialActivityCell

- (void)awakeFromNib {
    // Initialization code
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"officialActivityCell";
    CPOfficialActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPOfficialActivityCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


+ (instancetype)officialActivityCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"CPOfficialActivityCell" owner:nil options:nil] lastObject];
}


- (void)setActiveStatus:(NSArray *)activeStatus{
    _activeStatus = activeStatus;
    
    // 设置图片总数
    self.photoCount = activeStatus.count;
    
    // 设置图片轮播器
    [self setPicPlayWithStatus:activeStatus];
    
}

// 设置图片轮播器
- (void)setPicPlayWithStatus:(NSArray *)activeStatus{
    
    [self removeTimer];
    
    // 0.一些固定的尺寸参数
    CGFloat imageW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    
    // 1.添加图片到scrollView中
    for (int i = 0; i<activeStatus.count; i++) {
        // 取出对象
        CPOfficialActivity *activeStu = activeStatus[i];
        
        
        // 创建图片容器
        UIImageView *imageView = [[UIImageView alloc] init];
        // 设置图片显示格式
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        // 设置frame
        CGFloat imageX = i * imageW;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        // 设置图片
        NSURL *url = [NSURL URLWithString:activeStu.cover];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        
        
        // 蒙版
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        maskView.frame = CGRectMake(0, 89, [UIScreen mainScreen].bounds.size.width,62.5);
        [imageView addSubview:maskView];
        
        
        // 活动标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = activeStu.title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = ActiveTitleFont;
        titleLabel.x = 71;
        titleLabel.y = 3;
        [titleLabel sizeToFit];
        [maskView addSubview:titleLabel];
 
        
        // 截止时间内容
        UILabel *endTimeLabel = [[UILabel alloc] init];
        endTimeLabel.textColor = [UIColor whiteColor];
        endTimeLabel.text = activeStu.endStr;
        endTimeLabel.font = ActiveEndTimeFont;
        [endTimeLabel sizeToFit];
        endTimeLabel.y = 6;
        endTimeLabel.x = kScreenWidth - 10 - endTimeLabel.width;
        [maskView addSubview:endTimeLabel];
        endTimeLabel.alpha = 1;
        
        // 截止时间
        UILabel *endLabel = [[UILabel alloc] init];
        endLabel.textColor = [UIColor whiteColor];
        endLabel.text = @"截止时间：";
        endLabel.font = ActiveEndTimeFont;
        endLabel.y = endTimeLabel.y;
        [endLabel sizeToFit];
        endLabel.x = maskView.width - 10 - endTimeLabel.width - endLabel.width;
        [maskView addSubview:endLabel];
        endLabel.alpha = 1;
        
        // 活动内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.font = ActiveContentFont;
        contentLabel.numberOfLines = 0;
        contentLabel.text = activeStu.content;
        CGFloat contentX = 15;
        CGFloat contentY = CGRectGetMaxY(titleLabel.frame);
        CGFloat contentMaxW = maskView.width - 24;
        CGSize contentSize = [activeStu.content sizeWithFont:ActiveContentFont constrainedToSize:CGSizeMake(contentMaxW, MAXFLOAT)];
        contentLabel.frame = (CGRect){{contentX,contentY},contentSize};
        [maskView addSubview:contentLabel];
        contentLabel.alpha = 1;
        
        // 图片容器添加蒙版容器
        [imageView addSubview:maskView];
        
        
        // 活动logo
        UIImageView *logoImageView = [[UIImageView alloc] init];
        logoImageView.layer.cornerRadius = 25;
        logoImageView.layer.masksToBounds = YES;
        NSURL *logoUrl = [NSURL URLWithString:activeStu.logo];
        [logoImageView sd_setImageWithURL:logoUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
        logoImageView.frame = CGRectMake(10, 59, 50, 50);
        [imageView addSubview:logoImageView];
        
        [self.scrollView addSubview:imageView];
    }
    
    // 2.设置内容尺寸
    CGFloat contentW = activeStatus.count * imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 3.隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.分页
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
 
    // 添加定时器(每隔5秒调用一次self 的nextImage方法)
    [self addTimer];
}



/**
 *  添加定时器
 */
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
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
    if (self.currentPage == self.photoCount - 1) {
        self.currentPage = 0;
    } else {
        self.currentPage += 1;
    }
    
    // 2.计算scrollView滚动的位置
    CGFloat offsetX = self.currentPage * self.scrollView.frame.size.width;
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
//    CGFloat scrollW = scrollView.frame.size.width;
//    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
//    self.pageControl.currentPage = page;
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
