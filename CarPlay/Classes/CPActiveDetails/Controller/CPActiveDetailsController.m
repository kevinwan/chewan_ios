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
#import "UIView+Dealer.h"
#import "NSDictionary+Dealer.h"
#import "AppAppearance.h"

@interface CPActiveDetailsController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

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

// 编辑活动按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editorActiveBtn;

// 编辑活动点击
- (IBAction)editorActive:(id)sender;

// 发送按钮
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

// 发送按钮点击
- (IBAction)sendClick:(id)sender;

// 要发送的信息
@property (weak, nonatomic) IBOutlet UITextField *sendText;

// 缓存cell高度（线程安全、内存紧张时会自动释放、不会拷贝key）
@property (nonatomic,strong) NSCache *rowHeightCache;

// 存储所有活动详情数据
@property (nonatomic,strong) CPActiveStatus *activeStatus;

// 存储所有评论数据
@property (nonatomic,strong) NSMutableArray *discussStatus;

// 上滑加载条数
@property (nonatomic,assign) NSInteger ignoreNum;

// 遮盖
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) UIView *carView;
@property (weak, nonatomic) IBOutlet UIView *carxibYesView;
@property (weak, nonatomic) IBOutlet UIView *carxibNoVIew;
@property (weak, nonatomic) IBOutlet UITextField *carxibTextFeild;
@property (nonatomic, strong) NSMutableArray *pickerArray;
@property (weak, nonatomic) IBOutlet UICollectionView *iconsView;
@end

@implementation CPActiveDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载网络Api数据
    [self loadApiData];
    
    // 加载评论数据
    [self loadDiscussDataWithIgnore:0];
    
    // 加载键盘处理事件
    [self loadKeyboard];
    
    // 设置标题
    self.title = @"活动详情";
    
    // 发送按钮切圆
    self.sendBtn.layer.cornerRadius = 3;
    self.sendBtn.layer.masksToBounds = YES;
    
    // 添加下拉刷新控件（头部）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownLoadData)];
    header.arrowView.image = [UIImage imageNamed:@"refreshArrow"];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.automaticallyChangeAlpha = YES;
    header.stateLabel.textColor = [Tools getColor:@"aab2bd"];
    header.lastUpdatedTimeLabel.textColor = [Tools getColor:@"aab2bd"];
    
    self.tableView.header = header;
    
    // 添加上拉刷新控件（底部）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upglideLoadData)];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.automaticallyChangeAlpha = YES;
    footer.stateLabel.textColor = [Tools getColor:@"aab2bd"];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多数据" forState:MJRefreshStateNoMoreData];
    
    self.tableView.footer = footer;
    
}

// 下拉刷新
- (void)dropDownLoadData{
    
    // 计数清零
    self.ignoreNum = 0;
    
    // 刷新活动详情
    [self loadApiData];
    [self loadDiscussDataWithIgnore:0];
    
}

// 上滑
- (void)upglideLoadData{
    self.ignoreNum += CPPageNum;
    [self loadDiscussDataWithIgnore:self.ignoreNum];
}


// 加载tableview的顶部
- (void)loadHeadView{
    // 创建tableheadview
    CPActiveDetailsHead *headView = [CPActiveDetailsHead headView:self];

    CGFloat headViewX = 0;
    CGFloat headViewY = 0;
    CGFloat headViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat headViewH = [headView xibHeightWithActiveStatus:self.activeStatus];
    
    headView.frame = CGRectMake(headViewX, headViewY, headViewW, headViewH);
    
    if (headView.goTaDetails == nil) {
        __weak typeof(self) weakSelf = self;
        headView.goTaDetails = ^{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil];
            
            CPTaDetailsController *taViewController = sb.instantiateInitialViewController;
            taViewController.targetUserId = self.createrId;
            
            [weakSelf.navigationController pushViewController:taViewController animated:YES];

        };
    }
    
    
    // 传递对象数据
    headView.activeStatus = self.activeStatus;
    
    // 将创建好的headview加到tableview上
    self.tableView.tableHeaderView = headView;
    //点击小头像手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIconsView)];
    [self.iconsView addGestureRecognizer:tap];
    
}


// 加载活动信息
- (void)loadApiData{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

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
        
        
        NSDictionary *dicts = responseObject[@"data"];
        
        // 取出活动数据
        self.activeStatus = [CPActiveStatus objectWithKeyValues:dicts];
        
        // 取出被访问者的id
        self.createrId = self.activeStatus.organizer.userId;
        
        // 设置编辑活动按钮
        if (self.activeStatus.isOrganizer) {
            self.editorActiveBtn.title = @"编辑活动";
        }else{
            [self.editorActiveBtn setTitle:@"收藏"];
        }
        
        
        // 加载headview
        [self loadHeadView];

        // 刷新表格
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
       
    }];
}


// 加载评论数据
- (void)loadDiscussDataWithIgnore:(NSInteger)ignore{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"ignore"] = @(ignore);
    
    if (self.userId != nil) {
        parameters[@"userId"] = self.userId;
    }
    if (self.token != nil) {
        parameters[@"token"] = self.token;
    }
    
    
    // 获取网络访问者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *getUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/activity/%@/comment",self.activeId];
    
    // 发送请求
    [manager GET:getUrl parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        
        NSArray *models = [CPDiscussStatus objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if (!ignore) {
            [self.discussStatus removeAllObjects];
            [self.discussStatus addObjectsFromArray:models];
        }else{
            [self.discussStatus addObjectsFromArray:models];
        }
        
        
        // 刷新界面
        [self.tableView reloadData];
        
        // 关闭下拉刷新
        [self.tableView.header endRefreshing];
        
        // 关闭上拉刷新
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        [SVProgressHUD showErrorWithStatus:@"获取评论失败"];
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

    return self.discussStatus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

// 点击cell弹出回复框
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 文本框成为第一响应者
//    [self.inputView becomeFirstResponder];
//    
//    CPDiscussStatus *disStatus = self.discussStatus[indexPath.row];
//    
//    NSString *phStr = [NSString stringWithFormat:@"回复%@：",disStatus.replyUserName];
//    
//    self.inputView.placeholder = phStr;
    
}

// 当开始拖拽tableview表格的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //退出键盘
    [self.view endEditing:YES];
}


#pragma mark - 文本框代理
// 点击发送按钮调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 发送评论
    [self sendMessage];
    
    return YES;
}

// 发送事件
- (void)sendMessage{
    
    if (!CPUnLogin) {
        // 封装请求参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        
        parameters[@"comment"] = self.sendText.text;
        
        // 获取网络访问者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 传递参数格式为josn
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // post地址
        NSString *postUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/activity/%@/comment?userId=%@&token=%@",self.activeId,self.userId,self.token];
        
        [manager POST:postUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            // 清除文本框文字
            self.sendText.text = @"";
            
            // 弹出提示信息
            [SVProgressHUD showInfoWithStatus:@"发布评论成功"];
            
            //退出键盘
            [self.view endEditing:YES];
            
            // 重新获取数据
            [self loadDiscussDataWithIgnore:0];
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }];

    }else{
        // 未登录跳到登录页面
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
    }
    
    
    
    
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

// 所有评论数据
- (NSMutableArray *)discussStatus{
    if (!_discussStatus) {
        _discussStatus = [NSMutableArray array];
    }
    return _discussStatus;
}

// 上拉刷新条数
- (NSInteger)ignoreNum{
    if (!_ignoreNum) {
        _ignoreNum = CPPageNum;
    }
    return _ignoreNum;
}

// 点击小头像方法
- (void)tapIconsView {
    if (self.activeStatus.isOrganizer) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
        
        MembersManageController * vc = sb.instantiateInitialViewController;
        vc.activityId = self.activeId;
        [self.navigationController pushViewController:vc animated:YES];

    } else  {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
        MembersController * vc = sb.instantiateInitialViewController;
        vc.activityId = self.activeId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 我要去玩按钮点击事件
- (IBAction)GotoPlayButtonDidClick:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"努力加载中"];
    //登陆状态下可点 拿出创建者字段,非登陆 自动跳转登陆界面
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/info",self.activeId];
    [CPNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self disMiss];
        if ([responseObject operationSuccess]) {
            SQLog(@"%@",responseObject);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            NSString *strOrganizer = [formatter stringFromNumber:responseObject[@"data"][@"isOrganizer"]];
            NSString *strMember = [formatter stringFromNumber:responseObject[@"data"][@"isMember"]];
            NSString *userId = [Tools getValueFromKey:@"userId"];
            SQLog(@"%@",userId);
            SQLog(@"%@",strMember);
            SQLog(@"%@",self.activeId);
            //根据isOrganizer判断进入那个界面
            if ([strOrganizer isEqualToString:@"1"]) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
                
                MembersManageController * vc = sb.instantiateInitialViewController;
                vc.activityId = self.activeId;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else if ([strMember isEqualToString:@"1"]){
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
                MembersController * vc = sb.instantiateInitialViewController;
                vc.activityId = self.activeId;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                NSString *userId = [Tools getValueFromKey:@"userId"];
                NSString *token = [Tools getValueFromKey:@"token"];
                NSString *urlStr = [NSString stringWithFormat:@"v1/user/%@/seats?token=%@&activityId=%@",userId,token,self.activeId];
                //主车提供后台返回的车 非车主最多提供两辆车
                [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
                    if ([responseObject operationSuccess]) {
                        SQLog(@"%@",responseObject);
                        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                        NSString *str = [formatter stringFromNumber:responseObject[@"data"][@"isAuthenticated"]];
                        if ([str isEqualToString:@"1"]) {
                            // 遮盖
                            UIButton *cover = [[UIButton alloc] init];
                            self.cover = cover;
                            cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                            [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
                            cover.frame = [UIScreen mainScreen].bounds;
                            [self.view.window addSubview:cover];
                            UIView *carView = [[[NSBundle mainBundle]loadNibNamed:@"CPActiveOfferCar" owner:self options:nil]lastObject];
                            CGFloat carViewX = self.view.window.center.x;
                            CGFloat carViewY = self.view.window.center.y - 100;
                            carView.center = CGPointMake(carViewX, carViewY);
                            self.carView = carView;
                            [self.view.window addSubview:carView];
                            //注意加载之后才有xib
                            UITapGestureRecognizer *tapYes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapYes)];
                            [self.carxibYesView addGestureRecognizer:tapYes];
                            UITapGestureRecognizer *tapNo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNo)];
                            [self.carxibNoVIew addGestureRecognizer:tapNo];
                            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                            int maxSeat = [[formatter stringFromNumber:responseObject[@"data"][@"maxValue"]] intValue];
                            int minSeat = [[formatter stringFromNumber:responseObject[@"data"][@"minValue"]] intValue];
                            [self.pickerArray removeAllObjects];
                            for (int i = minSeat; i <= maxSeat; i++) {
                                NSString *seat = [NSString stringWithFormat:@"%tu",i];
                                [self.pickerArray addObject:seat];
                            }
                            UIPickerView *picker = [[UIPickerView alloc]init];
                            picker.delegate = self;
                            picker.dataSource = self;
                            self.carxibTextFeild.inputView = picker;
                            self.carxibTextFeild.delegate = self;
                            self.carxibTextFeild.font = [AppAppearance textMediumFont];
                            self.carxibTextFeild.textColor = [AppAppearance textDarkColor];
                            [self tapYes];
                           
                        } else {
                            NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/join",self.activeId];
                            [CPNetWorkTool postJsonWithUrl:urlStr params:nil success:^(id responseObject) {
                                if ([responseObject operationSuccess]) {
                                    [self.view alert:@"请求成功,等待同意"];
                                } else {
                                    [self.view alertError:responseObject];
                                }
                            } failed:^(NSError *error) {
                                [self.view alertError:error];
                            }];
                            
 
                        
                        }
                        
                    } else {
                        [self.view alertError:responseObject];
                    }
                } failure:^(NSError *error) {
                    [self.view alertError:error];
                }];
               
                
            }
            
        } else {
            [self.view alertError:responseObject];
        }
        
    } failure:^(NSError *error) {
        [self.view alertError:error];
    }];
}

// 编辑活动按钮
- (IBAction)editorActive:(id)sender {
    if ([self.editorActiveBtn.title isEqualToString:@"关注"]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *postUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/activity/%@/subscribe?userId=%@&token=%@",self.activeId,self.userId,self.token];
        
        [manager POST:postUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            //
//            NSLog(@"msg = %@",responseObject[@"errmsg"]);
//            NSLog(@"关注成功");
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //
        }];
        
    }else{
        CPEditActivityController *vc = [UIStoryboard storyboardWithName:@"CPEditActivityController" bundle:nil].instantiateInitialViewController;
        vc.data = [self.activeStatus keyValues]; // 字典
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

//点击提交
- (IBAction)carxibButtonClick:(UIButton *)sender {
    
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/join",self.activeId];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *seatStr = self.carxibTextFeild.text;
    if (seatStr.length!= 0) {
        parameters[@"seat"] = seatStr;
    } else {
        parameters[@"seat"] = @"0";
    }
    
    [self coverClick];
    [CPNetWorkTool postJsonWithUrl:urlStr params:parameters success:^(id responseObject) {
        if ([responseObject operationSuccess]) {
            [self.view alert:@"请求成功,等待同意"];
        } else {
            [self.view alertError:responseObject];
        }
    } failed:^(NSError *error) {
        [self.view alertError:error];
    }];
    
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.carxibTextFeild.text = [NSString stringWithFormat:@"%@",self.pickerArray[row]];
}


- (void)tapYes {
    self.carxibTextFeild.enabled = YES;
    [self.carxibTextFeild becomeFirstResponder];
}
- (void)tapNo {
    self.carxibTextFeild.enabled = NO;
    [self.carxibTextFeild resignFirstResponder];
    self.carxibTextFeild.text = nil;
}

- (void)coverClick {
    [_cover removeFromSuperview];
    _cover = nil;
    
    [_carView removeFromSuperview];
    _carView = nil;
}
#pragma mark - lazy
- (NSMutableArray *)pickerArray {
    if (!_pickerArray) {
        _pickerArray = [[NSMutableArray alloc]init];
    }
    return _pickerArray;
}

// 发送按钮点击
- (IBAction)sendClick:(id)sender {
    [self sendMessage];
}
@end
