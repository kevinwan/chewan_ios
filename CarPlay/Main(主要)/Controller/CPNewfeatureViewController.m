//
//  XMNewfeatureViewController
//  xiaoma
//
//  Created by apple on 14-7-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#define XMNewfeatureImageCount 5

#import "CPNewfeatureViewController.h"
#import "CPTabBarController.h"
#import "AppDelegate.h"

@interface CPNewfeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation CPNewfeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.添加UISrollView
    [self setupScrollView];
//    
//    // 2.添加pageControl
//    [self setupPageControl];
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    // 1.添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (int i = 0; i<XMNewfeatureImageCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        if (iPhone4) { // 4inch  需要手动去加载4inch对应的-568h图片
            name = [name stringByAppendingString:@"_480h"];
        }else if (iPhone5){
             name = [name stringByAppendingString:@"_568h"];
        }else if (iPhone6){
            name = [name stringByAppendingString:@"_667h"];
        }else if (iPhone6P){
            name = [name stringByAppendingString:@"_736h"];
        }
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 设置frame
        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i * imageW;
        
        // 给最后一个imageView添加按钮
        if (i == XMNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(XMNewfeatureImageCount * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
#warning 别在scrollView.subviews中通过索引来查找对应的子控件
//    [scrollView.subviews lastObject];
}

/**
 设置最后一个UIImageView中的内容
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    [self setupStartButton:imageView];

}

/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [imageView addSubview:startButton];
    
    // 2.设置背景图片
    
    // 3.设置frame
    startButton.size = CGSizeMake(self.view.width * 0.5, 50);
    startButton.centerX = self.view.middleX;
    startButton.y = self.view.height - 110;
    startButton.backgroundColor=[UIColor clearColor];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  开始首页
 */
- (void)start
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [(AppDelegate *)[UIApplication sharedApplication].delegate tabVc];
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    // 获得页码
//    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
//    int intPage = (int)(doublePage + 0.5);
//    
//    // 设置页码
//    self.pageControl.currentPage = intPage;
//}


@end
