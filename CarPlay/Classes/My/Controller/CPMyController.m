//
//  CPMyController.m
//  CarPlay
//
//  Created by 公平价 on 15/6/19.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyController.h"
#import "LoginViewController.h"
#import "CPMyheaderView.h"
#import "CPMySubscribeModel.h"
#import "CPMyBaseCell.h"
#import "CPSettingTableViewController.h"
#import "CPMyPublishController.h"
#import "CPMySubscribeController.h"
#import "CPMyJoinController.h"
#import "CarOwnersCertificationViewController.h"
#import "CPHowToPlayViewController.h"
#import "CPFeedbackViewController.h"
#import "CPEditInfoTableViewController.h"
#import "CPPhotoalbumManagement.h"
#import "CPSubscribePersonController.h"

@interface CPMyController ()<UIScrollViewDelegate>
{
    NSDictionary *data;
    NSArray *albumPhotos;
    NSArray *titleArray;
    NSArray *iconArray;
}
@end

@implementation CPMyController

- (void)viewDidLoad {
    [super viewDidLoad];
    data=[[NSDictionary alloc]init];
    albumPhotos=[[NSArray alloc]init];
    titleArray=[[NSArray alloc]initWithObjects:@"我关注的人",@"车主认证",@"玩转玩车",@"意见反馈",@"编辑资料", nil];
    iconArray=[[NSArray alloc]initWithObjects:@"我关注的人",@"车主认证",@"玩转玩车",@"意见反馈",@"活动介绍", nil];
    self.userHeadImg.layer.cornerRadius=25;
    self.userHeadImg.layer.masksToBounds=YES;
    self.loginBtn.layer.cornerRadius=15;
    self.loginBtn.layer.masksToBounds=YES;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithNorImage:@"设置icon" higImage:nil title:nil target:self action:@selector(leftBtnClick:)];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithNorImage:@"拍照" higImage:nil title:nil target:self action:@selector(photoManage:)];
    // 设置图片
    [self createScrollViewAndPagController];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if ([Tools getValueFromKey:@"userId"]) {
        self.unLoginStatusView.hidden=YES;
        [self getData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *cellIdentifier=@"CPMyBaseCell";
    CPMyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyBaseCell" owner:nil options:nil] lastObject];
    }
    cell.icon.image=[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]];
    cell.titleLable.text=[titleArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        CPSubscribePersonController *vc = [UIStoryboard storyboardWithName:@"CPSubscribePersonController" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1) {
        CarOwnersCertificationViewController *CarOwnersCertificationVC=[[CarOwnersCertificationViewController alloc]init];
        CarOwnersCertificationVC.fromMy=@"0";
        CarOwnersCertificationVC.title=@"车主认证";
        
        [self.navigationController pushViewController:CarOwnersCertificationVC animated:YES];
    }else if (indexPath.row==2){
        CPHowToPlayViewController *CPHowToPlayVC=[[CPHowToPlayViewController alloc]init];
        CPHowToPlayVC.title=@"玩转玩车";
        [self.navigationController pushViewController:CPHowToPlayVC animated:YES];
    }else if (indexPath.row==3){
        CPFeedbackViewController *CPFeedbackVC=[[CPFeedbackViewController alloc]init];
        CPFeedbackVC.title=@"意见反馈";
        [self.navigationController pushViewController:[UIStoryboard storyboardWithName:@"CPFeedbackViewController" bundle:nil].instantiateInitialViewController animated:YES];
    }else if (indexPath.row==4){
        CPEditInfoTableViewController *CPEditInfoTableVC=[[CPEditInfoTableViewController alloc]init];
        CPEditInfoTableVC.title=@"编辑资料";
        [self.navigationController pushViewController:CPEditInfoTableVC animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (IBAction)photoManage:(id)sender {
    if ([Tools getValueFromKey:@"userId"]) {
        CPPhotoalbumManagement *CPPhotoalbumManagementVC=[[CPPhotoalbumManagement alloc]init];
        CPPhotoalbumManagementVC.title=@"相册管理";
        CPPhotoalbumManagementVC.albumPhotos=albumPhotos;
        [self.navigationController pushViewController:CPPhotoalbumManagementVC animated:YES];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
    }
}

// 分页控件的监听方法
- (void)pageChanged:(UIPageControl *)page
{
    //    NSLog(@"%d", page.currentPage);
    
    // 根据页数，调整滚动视图中的图片位置 contentOffset
    CGFloat x = page.currentPage * self.scrollView.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)startTimer
{
//    if (self.timer) {
//        [self.timer invalidate];
//    }
    
    self.timer = [NSTimer timerWithTimeInterval:2.3 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    // 添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateTimer
{
    // 页号发生变化
    // (当前的页数 + 1) % 总页数
    int page = (self.pageControl.currentPage + 1) % [albumPhotos count];
    self.pageControl.currentPage = page;
    
    //    NSLog(@"%d", self.pageControl.currentPage);
    // 调用监听方法，让滚动视图滚动
    [self pageChanged:self.pageControl];
}

#pragma mark - ScrollView的代理方法
// 滚动视图停下来，修改页面控件的小点（页数）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    // 计算页数
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
//    int page = (self.pageControl.currentPage - 1);
    
    self.pageControl.currentPage = page;
}

/**
 修改时钟所在的运行循环的模式后，抓不住图片
 
 解决方法：抓住图片时，停止时钟，送售后，开启时钟
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    NSLog(@"%s", __func__);
    // 停止时钟，停止之后就不能再使用，如果要启用时钟，需要重新实例化
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"%s", __func__);
    if ([albumPhotos count]>0) {
        [self startTimer];
    }
    
}

-(void)createScrollViewAndPagController{
    // 取消弹簧效果
    _scrollView.bounces = NO;
    
    // 取消水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    // 要分页
    _scrollView.pagingEnabled = YES;
    
    // contentSize
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, 0);
    
    // 设置代理
    _scrollView.delegate = self;
    
    [_scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    
    UIImage *image = [UIImage imageNamed:@"myBackground"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    
    imageView.image = image;
    imageView.contentMode=UIViewContentModeScaleToFill;
    [self.scrollView addSubview:imageView];
    
    // 分页控件，本质上和scrollView没有任何关系，是两个独立的控件
    _pageControl = [[UIPageControl alloc] init];
}

-(void)getData{
    NSString *path=[[NSString alloc]initWithFormat:@"v1/user/%@/info",[Tools getValueFromKey:@"userId"]];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:[Tools getValueFromKey:@"userId"],@"userId",[Tools getValueFromKey:@"token"],@"token", nil];
    [ZYNetWorkTool getWithUrl:path params:params success:^(id responseObject) {
        if (CPSuccess) {
            data=[responseObject objectForKey:@"data"];
            if(data && [data objectForKey:@"albumPhotos"]){
                albumPhotos=[data objectForKey:@"albumPhotos"];
            }
            if (data) {
                CPOrganizer *organizer= [CPOrganizer objectWithKeyValues:data];
                NSString *fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"userId"]];
                [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
                [self loadUserData:organizer];
            }
        }
    } failure:^(NSError *error) {
        [self showError:@"获取个人信息失败"];
    }];
}

-(void)loadUserData:(CPOrganizer *)organizer{
    if (organizer) {
        if (organizer.albumPhotos && [organizer.albumPhotos count]>0) {
            // 总页数
            _pageControl.numberOfPages = [albumPhotos count];
            _pageControl.bounds = CGRectMake(0, 0, 7, 7);
            _pageControl.center = CGPointMake(self.view.center.x, 180);
            
            // 设置颜色
            _pageControl.pageIndicatorTintColor = [Tools getColor:@"ffffff"];
            _pageControl.currentPageIndicatorTintColor = [Tools getColor:@"48d1d5"];
            
            [self.view addSubview:_pageControl];
            
            // 添加监听方法
            /** 在OC中，绝大多数"控件"，都可以监听UIControlEventValueChanged事件，button除外" */
            [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
            
            for (int i = 0; i < [albumPhotos count]; i++) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
                NSString *urlstr=[[albumPhotos objectAtIndex:i] objectForKey:@"thumbnail_pic"];
                if (urlstr) {
                    NSURL *url=[[NSURL alloc]initWithString:urlstr];
                    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"myBackground"]];
                    CGRect frame = imageView.frame;
                    frame.origin.x = i * frame.size.width;
                    
                    imageView.frame = frame;
                    imageView.contentMode=UIViewContentModeScaleAspectFill;
                    [self.scrollView addSubview:imageView];
                }
                self.scrollView.delegate=self;
            }
            self.pageControl.currentPage = 0;
            // 启动时钟
            [self startTimer];
        }
        
        if (organizer.photo) {
            NSURL *url = [[NSURL alloc]initWithString:organizer.photo];
            [Tools setValueForKey:organizer.photo key:@"photoUrl"];
            [self.userHeadImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"morenHeadBtnImg"]];
            
        }
        
        if (organizer.nickname) {
            UIFont *font = [UIFont systemFontOfSize:16.0f];
            CGSize size = CGSizeMake(SCREEN_WIDTH-120.0,100.0);
            CGSize labelsize = [organizer.nickname sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            [self.nameLable setWidth:labelsize.width];
            self.nameLable.text = organizer.nickname;
            [self.userGenderImg setX:self.nameLable.right+7.0];
            [Tools setValueForKey:organizer.nickname key:@"nickname"];
        }
        
        if (organizer.drivingExperience) {
            [Tools setValueForKey:@(organizer.drivingExperience) key:@"drivingExperience"];
        }
        
        if (!organizer.isMan) {
            [self.userGenderImg setImage:[UIImage imageNamed:@"女-1"]];
        }
        
        if (organizer.age) {
            self.ageLable.text=[[NSString alloc]initWithFormat:@"%ld",(long)organizer.age];
            [self.ageLable setX:self.userGenderImg.right-1-self.ageLable.width];
        }
        
        if (organizer.carBrandLogo && ![Tools isEmptyOrNull:organizer.carBrandLogo]) {
            NSURL *url=[[NSURL alloc]initWithString:organizer.carBrandLogo];
            [self.carBrandLogoImg sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                float weight=image.size.width/image.size.height*13.0;
                [self.carBrandLogoImg setWidth:weight];
                [self.carModelAndDrivingExperience setX:self.carBrandLogoImg.right];
            }];
        }
        
        if (organizer.carModel) {
            NSString *description=organizer.carModel;
            if (organizer.drivingExperience) {
                description=[[NSString alloc]initWithFormat:@"%@,%zd年驾龄",organizer.carModel,organizer.drivingExperience];
            }
            self.carModelAndDrivingExperience.text=description;
        }
        
        if (organizer.postNumber) {
            self.myReleaseCountLable.text=[[NSString alloc]initWithFormat:@"%zd",organizer.postNumber];
        }
        
        if (organizer.subscribeNumber) {
            self.myPayAttentionToCountLable.text=[[NSString alloc]initWithFormat:@"%zd",organizer.subscribeNumber];
        }
        
        if (organizer.joinNumber) {
            self.myParticipateInCountLable.text=[[NSString alloc]initWithFormat:@"%zd",organizer.joinNumber];
        }
    }
}

- (IBAction)loginBtnClick:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
}

- (IBAction)leftBtnClick:(id)sender {
    CPSettingTableViewController *CPSettingTableVC=[[CPSettingTableViewController alloc]init];
    CPSettingTableVC.title=@"设置";
    [self.navigationController pushViewController:CPSettingTableVC animated:YES];
}

//我的发布
- (IBAction)myRelease:(id)sender{
    self.myReleaseLable.backgroundColor=[Tools getColor:@"fc6e51"];
    [self.myReleaseCountLable setTextColor:[Tools getColor:@"fc6e51"]];
    [self.myReleaseBtnLable setTextColor:[Tools getColor:@"fc6e51"]];
    
    self.myPayAttentionToLable.backgroundColor=[UIColor whiteColor];
    [self.myPayAttentionToCountLable setTextColor:[Tools getColor:@"aab2bd"]];
    [self.myPayAttentionToBtnLable setTextColor:[Tools getColor:@"aab2bd"]];
    
    self.myParticipateInLable.backgroundColor=[UIColor whiteColor];
    [self.myParticipateInCountLable setTextColor:[Tools getColor:@"aab2bd"]];
    [self.myParticipateInBtnLable setTextColor:[Tools getColor:@"aab2bd"]];
    
    CPMyPublishController *vc = [[CPMyPublishController alloc] init];
    vc.hisUserId = [Tools getValueFromKey:@"userId"];
    [self.navigationController pushViewController:vc animated:YES];
}

//我的关注
- (IBAction)myPayAttentionTo:(id)sender{
    self.myReleaseLable.backgroundColor=[UIColor whiteColor];
    [self.myReleaseCountLable setTextColor:[Tools getColor:@"aab2bd"]];
    [self.myReleaseBtnLable setTextColor:[Tools getColor:@"aab2bd"]];
    
    self.myPayAttentionToLable.backgroundColor=[Tools getColor:@"fc6e51"];
    [self.myPayAttentionToCountLable setTextColor:[Tools getColor:@"fc6e51"]];
    [self.myPayAttentionToBtnLable setTextColor:[Tools getColor:@"fc6e51"]];
    
    self.myParticipateInLable.backgroundColor=[UIColor whiteColor];
    [self.myParticipateInCountLable setTextColor:[Tools getColor:@"aab2bd"]];
    [self.myParticipateInBtnLable setTextColor:[Tools getColor:@"aab2bd"]];
    
    CPMySubscribeController *vc = [[CPMySubscribeController alloc] init];
    vc.hisUserId = [Tools getValueFromKey:@"userId"];
    [self.navigationController pushViewController:vc animated:YES];
}

//我的参与
- (IBAction)myParticipateIn:(id)sender{
    
    self.myReleaseLable.backgroundColor=[UIColor whiteColor];
    [self.myReleaseCountLable setTextColor:[Tools getColor:@"aab2bd"]];
    [self.myReleaseBtnLable setTextColor:[Tools getColor:@"aab2bd"]];
    
    self.myPayAttentionToLable.backgroundColor=[UIColor whiteColor];
    [self.myPayAttentionToCountLable setTextColor:[Tools getColor:@"aab2bd"]];
    [self.myPayAttentionToBtnLable setTextColor:[Tools getColor:@"aab2bd"]];
    
    self.myParticipateInLable.backgroundColor=[Tools getColor:@"fc6e51"];
    [self.myParticipateInCountLable setTextColor:[Tools getColor:@"fc6e51"]];
    [self.myParticipateInBtnLable setTextColor:[Tools getColor:@"fc6e51"]];
    
    CPMyJoinController *vc = [[CPMyJoinController alloc] init];
    vc.hisUserId = [Tools getValueFromKey:@"userId"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
