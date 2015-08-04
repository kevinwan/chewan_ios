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
#import "MembersController.h"
#import "MembersManageController.h"
#import "CPDiscussCell.h"
#import "CPTaDetailsController.h"
#import "CPEditActivityController.h"

@interface CPActiveDetailsController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

// 用户ID
@property (nonatomic,copy) NSString *userId;

// 活动创建者
@property (nonatomic,copy) NSString *createrId;

// 用户token
@property (nonatomic,copy) NSString *token;

// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 评论框距离底部距离约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

// tableview距离顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

// 文本输入框
@property (weak, nonatomic) IBOutlet UITextField *inputView;

// 编辑活动
- (IBAction)editorActive:(id)sender;


// 缓存cell高度（线程安全、内存紧张时会自动释放、不会拷贝key）
@property (nonatomic,strong) NSCache *rowHeightCache;

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
    
//    headView.frame.size.height = [headView xibHeightWithActiveStatus:self.activeStatus];
    CGFloat headViewX = 0;
    CGFloat headViewY = 0;
    CGFloat headViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat headViewH = [headView xibHeightWithActiveStatus:self.activeStatus];
    
    headView.frame = CGRectMake(headViewX, headViewY, headViewW, headViewH);
    
    if (headView.goTaDetails == nil) {
        headView.goTaDetails = ^{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil];
            
            CPTaDetailsController *taViewController = sb.instantiateInitialViewController;
            taViewController.targetUserId = self.createrId;
            
            [self.navigationController pushViewController:taViewController animated:YES];

        };
    }
    
    
    // 传递对象数据
    headView.activeStatus = self.activeStatus;
    
    // 将创建好的headview加到tableview上
    self.tableView.tableHeaderView = headView;
    
}


// 加载活动信息
- (void)loadApiData{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
//    parameters[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
    if (self.userId != nil) {
        parameters[@"userId"] = self.userId;
    }
    if (self.token != nil) {
        parameters[@"token"] = self.token;
    }
    
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
        
        // 取出被访问者的id
        self.createrId = self.activeStatus.organizer.userId;
        
        
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

//    parameters[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
//    parameters[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
    
    
    
    // 获取网络访问者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *getUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/activity/%@/comment",self.activeId];
    
    // 发送请求
    [manager GET:getUrl parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        
//        NSLog(@"%@",self.activeId);
//         NSLog(@"%@",responseObject);
        self.discussStatus = [CPDiscussStatus objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        NSLog(@"%@",self.discussStatus);
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        //
    }];
    
}

// 监听键盘事件，通知中心
- (void)loadKeyboard{
    
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
        self.topConstraint.constant = 64;
    } else {
        CGRect r = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.bottomConstraint.constant = r.size.height;
        self.topConstraint.constant = 64 - r.size.height;
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
//    return 10;
    return self.discussStatus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        cell.textLabel.text = @"123";
    
    CPDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPDiscussCell identifier]];
    cell.discussStatus = self.discussStatus[indexPath.row];
    return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     // 取出对应行模型
    CPDiscussStatus *status = self.discussStatus[indexPath.row];
    
    // 先从缓存中获取高度，没有才计算
    NSNumber *rowHeight = [self.rowHeightCache objectForKey:status.userId];
    
    CGFloat cellHeight = [rowHeight doubleValue];
    
    if (rowHeight == nil) {
        
        // 取出cell
        CPDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPDiscussCell identifier]];
        
        // 获取高度
        cellHeight = [cell cellHeightWithDiscussStatus:status];
        
        // 缓存每一行的高度
        [self.rowHeightCache setObject:@(cellHeight) forKey:status.userId];
    }
    
    // 设置高度
    return cellHeight;
}



// 当开始拖拽tableview表格的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //退出键盘
    [self.view endEditing:YES];
}


#pragma mark - 文本框代理
// 点击发送按钮调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    
//    if (self.userId != nil) {
//        parameters[@"userId"] = self.userId;
//    }
//    if (self.token != nil) {
//        parameters[@"token"] = self.token;
//    }
    
//    NSLog(@"%@",textField.text);
//    NSLog(@"%@",self.activeId);
    parameters[@"comment"] = textField.text;
    
    // 获取网络访问者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 传递参数格式为josn
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // post地址
    NSString *postUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/activity/%@/comment?userId=%@&token=%@",self.activeId,self.userId,self.token];
    
    [manager POST:postUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
       
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        NSLog(@"调用失败");
    }];
    
    
    
    return YES;
}


#pragma mark - lazy(懒加载)
//// 用户id
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


// 我要去玩按钮点击事件
- (IBAction)GotoPlayButtonDidClick:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"成员管理"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
        
        MembersManageController * vc = sb.instantiateInitialViewController;
        vc.activityId = self.activeId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
        MembersController * vc = sb.instantiateInitialViewController;
        vc.activityId = self.activeId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 编辑活动按钮
- (IBAction)editorActive:(id)sender {
    CPEditActivityController *vc = [UIStoryboard storyboardWithName:@"CPEditActivityController" bundle:nil].instantiateInitialViewController;
    vc.data = [self.activeStatus keyValues]; // 字典
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
