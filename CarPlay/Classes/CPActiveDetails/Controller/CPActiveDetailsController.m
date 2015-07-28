//
//  CPActiveDetailsController.m
//  CPActiveDetailsDemo
//
//  Created by 公平价 on 15/7/1.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActiveDetailsController.h"
#import "CPActiveDetailsHead.h"
#import "AFNetworking.h"
#import "CPActiveStatus.h"
#import "MJExtension.h"
#import "CPActiveUser.h"
#import "CPDiscussStatus.h"


@interface CPActiveDetailsController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
// 数据源数组
@property (nonatomic,strong) NSMutableArray *activeInfos;

// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 评论框距离底部距离约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

// 文本输入框
@property (weak, nonatomic) IBOutlet UITextField *inputView;


// 存储所有活动详情数据
@property (nonatomic,strong) CPActiveStatus *activeStatus;

// 存储所有评论数据
@property (nonatomic,strong) NSArray *discussStatus;

@end

@implementation CPActiveDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载网络Api数据
    [self loadApiData];
    
    // 加载评论数据
    [self loadDiscussData];
    
    // 加载键盘处理事件
    [self loadKeyboard];
    
}

// 加载tableview的顶部
- (void)loadHeadView{
    // 创建tableheadview
    CPActiveDetailsHead *headView = [CPActiveDetailsHead headView:self];
    
    // 传递对象数据
    headView.activeStatus = self.activeStatus;
    
    // 将创建好的headview加到tableview上
    self.tableView.tableHeaderView = headView;
}


- (void)loadApiData{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
    parameters[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
    
    // 获取网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // get地址
    NSString *getUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/activity/%@/info",self.activeId];
    
    // 发送请求
    [manager GET:getUrl parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        
        
//        NSLog(@"%@",responseObject[@"data"]);
        
        NSDictionary *dicts = responseObject[@"data"];
        
        // 取出活动数据
        self.activeStatus = [CPActiveStatus objectWithKeyValues:dicts];
        
        // 加载headview
        [self loadHeadView];

        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        //
        NSLog(@"%@",error);
    }];
}


// 加载评论数据
- (void)loadDiscussData{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
    parameters[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
    
    // 获取网络访问者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 发送请求
    [manager GET:@"http://cwapi.gongpingjia.com/v1/activity/55838b12-7039-41e5-9150-6dd154de961b/comment" parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        //
//         NSLog(@"%@",responseObject[@"data"]);
        self.discussStatus = [CPDiscussStatus objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        NSLog(@"%@",self.discussStatus);
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        //
    }];
    
}


- (void)loadKeyboard{
    
    // 监听键盘事件，通知中心
    // 键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardStatus:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardStatus:) name:UIKeyboardWillHideNotification object:nil];
    
    // 设置文本输入框代理
    self.inputView.delegate = self;
}

- (void)dealloc{
    
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 键盘发生改变后调用的方法
- (void)keyboardStatus:(NSNotification *)n{
    
    
    //取出执行动画的时间
    CFTimeInterval duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    

    if ([n.name isEqualToString:UIKeyboardWillHideNotification]) {
        self.bottomConstraint.constant = 0.0;
    } else {
        CGRect r = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.bottomConstraint.constant = r.size.height;
    }
    
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        // 自动布局动画
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self scrollToSelectedRow];
    }];
    
    
}

- (void)scrollToSelectedRow {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



#pragma mark -数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.activeInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
  
}

#pragma mark - 代理方法
// 当开始拖拽tableview表格的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //退出键盘
    [self.view endEditing:YES];
}
//我要去玩按钮点击事件
- (IBAction)GotoPlayButtonDidClick:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
    UIViewController * vc = sb.instantiateInitialViewController;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
