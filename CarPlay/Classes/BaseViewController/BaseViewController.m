//
//  lbBaseViewController.m
//  LangBo.SuiPian
//
//  Created by yabusai-mac on 14-5-26.
//  Copyright (c) 2014年 langbo. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController (){
    
}

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBarTintColor:[Tools getColor:@"48d1d4"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //    点击其他地方隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNorImage:@"返回" higImage:nil title:nil target:self action:@selector(popBack)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLeftBarWithLeftImage:(NSString *)leftImage action:(SEL)leftAction
{
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(0, 0, 27, 27);
    if (leftImage) {
        [btn_back setBackgroundImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
        //        [btn_back setBackgroundImage:[UIImage imageNamed:leftImage] forState:UIControlStateHighlighted];
    }
    if (leftAction) {
        [btn_back addTarget:self action:leftAction forControlEvents:UIControlEventTouchUpInside];
    } else {
        [btn_back addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn_back];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setRightBarWithRightImage:(NSString *)rightImage action:(SEL)rightAction
{
    //右侧
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_right.frame = CGRectMake(0, 0, 22, 22);
    if (rightImage) {
        [btn_right setBackgroundImage:[UIImage imageNamed:rightImage] forState:UIControlStateNormal];
        //        [btn_right setBackgroundImage:[UIImage imageNamed:rightImage] forState:UIControlStateHighlighted];
    }
    if (rightAction) {
        [btn_right addTarget:self action:rightAction forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn_right];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRightBarBtnWithRightTitle:(NSString *)title target:(id)target action:(SEL)rightAction
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:rightAction];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setRightBarBtnWithRightTitle:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)rightAction{
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:rightAction];
        rightItem.tintColor = color;
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)popBack
{
    //判断是否rootViewController,并且当前选中的不是首页标签
    
    if(self.navigationController.viewControllers.count>1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//*************************************


#pragma mark - 设置标题
-(void) setTitle:(NSString *) strTitle{
    [self setTitle:strTitle textColor:[UIColor whiteColor]];
}

#pragma mark - 设置标题
-(void) setTitle:(NSString *) strTitle textColor:(UIColor *) color{
    CGSize sizeTitle =[strTitle sizeWithFont:[UIFont boldSystemFontOfSize:22]];
    UILabel * lblTitle = [[UILabel alloc ]initWithFrame:CGRectMake((SCREEN_WIDTH-sizeTitle.width)/2, (44-sizeTitle.height)/2, sizeTitle.width, sizeTitle.height)];
    lblTitle.text = strTitle;
    lblTitle.textColor = color;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont systemFontOfSize:20];
    [lblTitle sizeToFit];
    [self.navigationItem setTitleView:lblTitle];
}


#pragma mark - 设置左边按钮
-(void) setLeftBar:(NSString *)imgName{
    //0:dismissModalViewController   1：popViewController
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    UIImage *buttonImage = [UIImage imageNamed:imgName];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:buttonImage forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
}

- (void)leftBarClick:(id)sender {
    [self popBack];
}

#pragma mark - 设置返回按钮
-(void) setBackBar:(NSString *)imgName{
    UIImage *buttonImage = [UIImage imageNamed:imgName];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [rightButton setImage:buttonImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.backBarButtonItem = barItemRight;
}

#pragma mark - 设置右边按钮
-(void) setRightBar:(NSString *)imgName{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 25, 25);
    [rightButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = barItemRight;
}

-(void) setRightBarWithText:(NSString *)title{
    [self setRightBarWithTextColor:title textColor:[UIColor whiteColor]];
}

-(void) setRightBarWithTextColor:(NSString *)title textColor:(UIColor *)color{
    CGSize ziseTitle = [title sizeWithFont:[UIFont systemFontOfSize:18]];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
    rightButton.frame = CGRectMake(0, 0, ziseTitle.width, ziseTitle.height);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setTitle:title forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitleColor:color forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = barItemRight;
}

-(void) setLeftBarWithText:(NSString *)title{
    [self setLeftBarWithTextColor:title textColor:[UIColor whiteColor]];
}

-(void) setLeftBarWithTextColor:(NSString *)title textColor:(UIColor *)color{
    CGSize ziseTitle = [title sizeWithFont:[UIFont systemFontOfSize:18]];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
    leftButton.frame = CGRectMake(0, 0, ziseTitle.width, ziseTitle.height);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setTitle:title forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton setTitleColor:color forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barItemRight;
}

- (void)rightBarClick:(id)sender {
     
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


//    点击其他地方隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
@end
