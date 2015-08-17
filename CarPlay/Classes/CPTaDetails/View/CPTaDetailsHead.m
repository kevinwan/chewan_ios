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

// 用户id
@property (nonatomic,copy) NSString *userId;

// 用户token
@property (nonatomic,copy) NSString *token;

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

// 关注按钮点击事件
- (IBAction)careBtnClick:(id)sender;



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
    if (taStatus.carBrandLogo == nil || [taStatus.carBrandLogo isEqualToString:@""]) {    
        self.carBrandLogo.hidden = YES;
    }else{
        self.carBrandLogo.hidden = NO;
        NSURL *urlCarBrandLogo = [NSURL URLWithString:taStatus.carBrandLogo];
        [self.carBrandLogo sd_setImageWithURL:urlCarBrandLogo placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
    }
    
    

    
    // 设置状态
    NSString *tempCarModel = @"";     // 存储转换后的carModel
    NSString *tempDrivingExperience = @"";   // 存储转换后的drivingExperience
    
    // 车型是否为空
    if (taStatus.carModel == nil || [taStatus.carModel isEqualToString:@""])
    {}else{
        tempCarModel = taStatus.carModel;
    }
    
    // 驾龄是否为空
    if ( [taStatus.drivingExperience  isEqualToString:@"0"]|| taStatus.drivingExperience == nil || [taStatus.drivingExperience isEqualToString:@""]) {
        // 没有车的情况
        self.carModelConstraint.constant = 10;
        tempDrivingExperience = @"带我飞~";
        
    }else{
        //有车的情况
        
        if (taStatus.carBrandLogo == nil || [taStatus.carBrandLogo isEqualToString:@""]) {
            self.carModelConstraint.constant = 10;
        }else{
            self.carModelConstraint.constant = 31;
        }
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
    [self setPublishBtn:[Tools getColor:@"fc6e51"]];
    
    // 设置关注
    [self setCareBtn:[Tools getColor:@"aab2bd"]];
    
    // 设置参与
    [self setJoinBtn:[Tools getColor:@"aab2bd"]];
    
    // 设置关注按钮
    if ([taStatus.isSubscribed isEqualToString:@"1"]) {
        [self.care setTitle:@"已关注" forState:UIControlStateNormal];
    }
    
    
}

// 设置发布按钮
- (void)setPublishBtn:(UIColor *)color{
    // 1.设置按钮文字居中、显示多行文字
    self.taPublish.titleLabel.textAlignment = NSTextAlignmentCenter; // 文字居中
    self.taPublish.titleLabel.numberOfLines = 0; // 显示多行文字
    
    // 2.设置发布数量的字体大小、颜色
    NSDictionary *dictAttP1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:color}; // 属性字典
    if(!self.taStatus.postNumber){
        self.taStatus.postNumber = @"0";
    }
    
    NSMutableAttributedString *publishAttStr = [[NSMutableAttributedString alloc] initWithString:[self.taStatus.postNumber stringByAppendingString:@"\n"]attributes:dictAttP1];
    
    // 3.设置TA的发布的大小、颜色
    NSDictionary *dictAttP2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:color};
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
    NSDictionary *dictAttC1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:color}; // 属性字典
    
    if (!self.taStatus.subscribeNumber) {
        self.taStatus.subscribeNumber = @"0";
    }
    
    NSMutableAttributedString *careAttStr = [[NSMutableAttributedString alloc] initWithString:[self.taStatus.subscribeNumber stringByAppendingString:@"\n"]attributes:dictAttC1];
    
    // 3.设置TA的发布的大小、颜色
    NSDictionary *dictAttC2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:color};
    NSAttributedString *careAttStr1 = [[NSAttributedString alloc] initWithString:@"TA的收藏" attributes:dictAttC2];
    
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
    NSDictionary *dictAttJ1 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:color}; // 属性字典
    
    if (!self.taStatus.joinNumber) {
        self.taStatus.joinNumber = @"0";
    }
    
    NSMutableAttributedString *joinAttStr = [[NSMutableAttributedString alloc] initWithString:[self.taStatus.joinNumber stringByAppendingString:@"\n"]attributes:dictAttJ1];
    
    // 3.设置TA的发布的大小、颜色
    NSDictionary *dictAttJ2 = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:color};
    NSAttributedString *joinAttStr1 = [[NSAttributedString alloc] initWithString:@"TA的参与" attributes:dictAttJ2];
    
    // 4.拼接字符串
    [joinAttStr appendAttributedString:joinAttStr1];
    
    // 5.设置文字
    [self.taJoin setAttributedTitle:joinAttStr forState:UIControlStateNormal];
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
    if (self.photoCount == 0) {
        [self removeTimer];
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置图片显示格式
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        // 设置frame
        imageView.frame = CGRectMake(0, 0, imageW, imageH);
        
        // 设置图片
        imageView.image = [UIImage imageNamed:@"myBackground"];
        
        [self.scrollView addSubview:imageView];

    }
    
    for (int i = 0; i<self.photoCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置图片显示格式
        imageView.contentMode = UIViewContentModeScaleAspectFill;
     
        
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

#pragma mark - lazy(懒加载)
// 用户id
- (NSString *)userId{
    if (!_userId) {
        _userId = [Tools getValueFromKey:@"userId"];
    }
    return _userId;
}

// 用户token
- (NSString *)token{
    if (!_token) {
        _token = [Tools getValueFromKey:@"token"];
    }
    return _token;
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


// 发布按钮点击事件
- (IBAction)taPublishClick:(id)sender {
    // 设置底部线颜色
    self.publishView.backgroundColor = [Tools getColor:@"fc6e51"];
    self.careView.backgroundColor = [Tools getColor:@"e6e9ed"];
    self.joinView.backgroundColor = [Tools getColor:@"e6e9ed"];
    
    // 设置约束
    self.taPublishConstraint.constant = 4;
    self.taCareConstraint.constant = 5;
    self.taJoinConstraint.constant = 5;
    
    // 设置文字颜色
    [self setPublishBtn:[Tools getColor:@"fc6e51"]];
    [self setCareBtn:[Tools getColor:@"aab2bd"]];
    [self setJoinBtn:[Tools getColor:@"aab2bd"]];
    
    if (self.statusSelected != nil) {
        self.statusSelected(0,@"post");
    }
    
    
    
}

// 关注按钮点击事件
- (IBAction)taCareClick:(id)sender {
    // 设置底部线颜色
    self.publishView.backgroundColor = [Tools getColor:@"e6e9ed"];
    self.careView.backgroundColor = [Tools getColor:@"fc6e51"];
    self.joinView.backgroundColor = [Tools getColor:@"e6e9ed"];
    
    self.taPublishConstraint.constant = 5;
    self.taCareConstraint.constant = 4;
    self.taJoinConstraint.constant = 5;
    
    // 设置文字颜色
    [self setPublishBtn:[Tools getColor:@"aab2bd"]];
    [self setCareBtn:[Tools getColor:@"fc6e51"]];
    [self setJoinBtn:[Tools getColor:@"aab2bd"]];
    
    if (self.statusSelected != nil) {
        self.statusSelected(0,@"subscribe");
    }
    
}

// 参与按钮点击事件
- (IBAction)taJoinClick:(id)sender {
    // 设置底部线颜色
    self.publishView.backgroundColor = [Tools getColor:@"e6e9ed"];
    self.careView.backgroundColor = [Tools getColor:@"e6e9ed"];
    self.joinView.backgroundColor = [Tools getColor:@"fc6e51"];
    
    // 设置约束
    self.taPublishConstraint.constant = 5;
    self.taCareConstraint.constant = 5;
    self.taJoinConstraint.constant = 4;
    
    // 设置文字颜色
    [self setPublishBtn:[Tools getColor:@"aab2bd"]];
    [self setCareBtn:[Tools getColor:@"aab2bd"]];
    [self setJoinBtn:[Tools getColor:@"fc6e51"]];
    
    
    if (self.statusSelected != nil) {
        self.statusSelected(0,@"join");
    }
    
}

// 关注按钮点击事件
- (IBAction)careBtnClick:(id)sender {
    
    // 设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"targetUserId"] = self.taStatus.userId;
    
    // 获取网络访问者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *postUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/user/%@/listen?token=%@",self.userId,self.token];
    
    [manager POST:postUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self.care setTitle:@"已关注" forState:UIControlStateNormal];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    

}
@end
