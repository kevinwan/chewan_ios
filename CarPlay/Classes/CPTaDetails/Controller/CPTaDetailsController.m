//
//  CPTaDetailsController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaDetailsController.h"
#import "AFNetworking.h"
#import "CPTaPublishStatus.h"
#import "CPTaDetailsStatus.h"
#import "CPTaPhoto.h"
#import "MJExtension.h"
#import "CPTaPublishCell.h"
#import "CPTaDetailsHead.h"
#import "CPTaNoData.h"
#import "CPHomeStatusCell.h"
#import "CPHomeStatus.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "CPActiveDetailsController.h"
#import "UIResponder+Router.h"
#import "CPModelButton.h"
#import "ZHPickView.h"



@interface CPTaDetailsController () <ZHPickViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *taTableView;

// 用户id
@property (nonatomic,copy) NSString *userId;

// 用户token
@property (nonatomic,copy) NSString *token;

// 上滑加载条数
@property (nonatomic,assign) NSInteger ignoreNum;

// 存储所有他详情页的数据
@property (nonatomic,strong) CPTaDetailsStatus *taStatus;

// 存储发布内容数据
@property (nonatomic,strong) NSMutableArray *taPubStatus;

// 缓存cell高度（线程安全、内存紧张时会自动释放、不会拷贝key）
@property (nonatomic,strong) NSCache *rowHeightCache;
@property (nonatomic,strong) NSCache *otherRowHeightCache;

// 三种状态
@property (nonatomic,copy) NSString *threeStates;
//活动Id
@property (nonatomic, strong) NSString *activeId;
// 遮盖
@property (nonatomic, strong) UIButton *carCover;
@property (nonatomic, strong) UIView *carView;
@property (nonatomic, strong) NSMutableArray *pickerArray;
@property (nonatomic, strong) UITextField *carxibTextFeild;
@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, assign) BOOL tapYes;
@property (nonatomic, strong) ZHPickView *picker;

@end

@implementation CPTaDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载提醒
    [self showLoading];
    
    // 加载他的详情页面数据
    [self setupLoadTaStatus];
    
    // 加载他的发布
    [self setupLoadTaPublishStatusWithIgnore:0 SelectStr:@"post"];
    
    // 页面标题
    self.title = @"TA的详情";
    
    // 上拉下拉刷新
    [self topAndBottomRefresh];
    
}

- (void)topAndBottomRefresh{
    // 添加下拉刷新控件（头部）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownLoadData)];
    header.arrowView.image = [UIImage imageNamed:@"refreshArrow"];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.automaticallyChangeAlpha = YES;
    header.stateLabel.textColor = [Tools getColor:@"aab2bd"];
    header.lastUpdatedTimeLabel.textColor = [Tools getColor:@"aab2bd"];
    
    self.taTableView.header = header;
    
    // 添加上拉刷新控件（底部）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upglideLoadData)];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.automaticallyChangeAlpha = YES;
//    footer.automaticallyHidden = NO;
    footer.stateLabel.textColor = [Tools getColor:@"aab2bd"];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多数据" forState:MJRefreshStateNoMoreData];
    
    self.taTableView.footer = footer;
}


// 下拉刷新
- (void)dropDownLoadData{
    
    // 计数清零
    self.ignoreNum = 0;
    
    // 刷新他的详情
//    [self setupLoadTaStatus];
    
    if ([self.threeStates isEqualToString:@"post"]) {
        [self setupLoadTaPublishStatusWithIgnore:0 SelectStr:@"post"];
    }else if ([self.threeStates isEqualToString:@"join"]){
        [self setupLoadTaPublishStatusWithIgnore:0 SelectStr:@"join"];
    }else{
        [self setupLoadTaPublishStatusWithIgnore:0 SelectStr:@"subscribe"];
    }
    
}

// 上滑
- (void)upglideLoadData{
    self.ignoreNum += CPPageNum;
    
    if ([self.threeStates isEqualToString:@"post"]) {
        [self setupLoadTaPublishStatusWithIgnore:self.ignoreNum SelectStr:@"post"];
    }else if ([self.threeStates isEqualToString:@"join"]){
        [self setupLoadTaPublishStatusWithIgnore:self.ignoreNum SelectStr:@"join"];
    }else{
        [self setupLoadTaPublishStatusWithIgnore:self.ignoreNum SelectStr:@"subscribe"];
    }
}

- (void)setupLoadHeadView{
    CPTaDetailsHead *head = [CPTaDetailsHead headView];
    head.taStatus = self.taStatus;
    __weak typeof(self) weakSelf = self;
    head.statusSelected = ^(NSInteger ignore,NSString *selectStr){
        [weakSelf setupLoadTaPublishStatusWithIgnore:ignore SelectStr:selectStr];
    };
    self.taTableView.tableHeaderView = head;
}

#pragma mark - 加载网络数据

// 加载他的详情页面数据
- (void)setupLoadTaStatus{
    
    // 设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.userId != nil) {
        parameters[@"userId"] = self.userId;
    }
    if (self.token != nil) {
        parameters[@"token"] = self.token;
    };;
    
 
//    // 获取网络访问者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *getUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/user/%@/info",self.targetUserId];
    
    
//    // 发送请求
//    [manager GET:getUrl parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
//        
//        
//        // 字典转模型
//        self.taStatus = [CPTaDetailsStatus objectWithKeyValues:responseObject[@"data"]];
//        
//        // 加载headview
//        [self setupLoadHeadView];
//        
//        [self.tableView reloadData];
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        //
//    }];
    
    [ZYNetWorkTool getWithUrl:getUrl params:parameters success:^(id responseObject) {
        [self disMiss];
        if (CPSuccess) {
            // 字典转模型
            self.taStatus = [CPTaDetailsStatus objectWithKeyValues:responseObject[@"data"]];
            
            // 加载headview
            [self setupLoadHeadView];
            
            [self.taTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [self showError:@"加载失败"];
    }];
    
    
    
}


// 加载他的详情发布
- (void)setupLoadTaPublishStatusWithIgnore:(NSInteger)ignore SelectStr:(NSString *)selectStr{
    
    self.threeStates = selectStr;
    
    // 设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"ignore"] = @(ignore);
    
    if (self.userId != nil) {
        parameters[@"userId"] = self.userId;
    }
    if (self.token != nil) {
        parameters[@"token"] = self.token;
    }
    
    
    NSString *getUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/user/%@/%@",self.targetUserId,selectStr];
    
    
    
    [ZYNetWorkTool getWithUrl:getUrl params:parameters success:^(id responseObject) {
        
        if (CPSuccess) {
            // 去出他发布的数据
            NSArray *taPubArr = responseObject[@"data"];
            
//            NSLog(@"%@",responseObject[@"data"]);
            
            // 字典数组转模型数组
            NSArray *models = [CPTaPublishStatus objectArrayWithKeyValuesArray:taPubArr];
            
            if (!ignore) {
                [self.taPubStatus removeAllObjects];
                [self.taPubStatus addObjectsFromArray:models];
            }else{
                [self.taPubStatus addObjectsFromArray:models];
            }
            
            // 如果返回数据为空，则显示无数据footerView
            if (self.taPubStatus.count == 0) {
                CPTaNoData *noData = [CPTaNoData footerView];
                __weak typeof(self) weakSelf = self;
                noData.publishRightNow = ^{
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPCreatActivityController" bundle:nil];
                    
                    [weakSelf.navigationController pushViewController:sb.instantiateInitialViewController animated:YES];
                };
                if ([selectStr isEqualToString:@"post"]) {
                    noData.pictureName = @"暂无发布";
                    noData.titleName = @"他还没有发布活动噢~";
                    noData.isShowBtn = NO;
                }else if([selectStr isEqualToString:@"subscribe"]){
                    noData.pictureName = @"暂无收藏";
                    noData.titleName = @"他还没有收藏活动噢~";
                    noData.isShowBtn = NO;
                }else{
                    noData.pictureName = @"暂无参与";
                    noData.titleName = @"他还没有参与活动噢~";
                    noData.isShowBtn = NO;
                }
                self.taTableView.tableFooterView = noData;
            }else{
                self.taTableView.tableFooterView = nil;
            }
            
            // 刷新tableview
            [self.taTableView reloadData];
            
            // 关闭下拉刷新
            [self.taTableView.header endRefreshing];
            // 关闭上拉刷新
            [self.taTableView.footer endRefreshing];
            
            // 重置底部上拉或者点击加载更多
            if (ignore == 0) {
                [self.taTableView.footer resetNoMoreData];
            }
            // 设置无更多数据
            if (models.count == 0) {
                [self.taTableView.footer noticeNoMoreData];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}



#pragma mark - 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taPubStatus.count;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if ([self.threeStates isEqualToString:@"post"]) {
        // 创建cell
        CPTaPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPTaPublishCell identifier]];
        
        //第一行处理
        if (indexPath.row == 0) {
            cell.isFirst = YES;
        }else{
            cell.isFirst = NO;
        }
        
        // 设置数据
        cell.publishStatus = self.taPubStatus[indexPath.row];
        
        // 弹出图片浏览器
        if (cell.taPictureDidSelected == nil) {
            //        __weak typeof(self) weakSelf = self;
            cell.taPictureDidSelected = ^(CPTaPublishStatus *status,NSIndexPath *path, NSArray *srcView){
                
                
                // 1.创建图片浏览器
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                NSArray *urls = [status.cover valueForKeyPath:@"original_pic"];
                // 2.设置图片浏览器显示的所有图片
                NSMutableArray *photos = [NSMutableArray array];
                NSUInteger count = urls.count;
                for (int i = 0; i<count; i++) {
                    
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    // 设置图片的路径
                    photo.url = [NSURL URLWithString:urls[i]];
                    // 设置来源于哪一个UIImageView
                    photo.srcImageView = srcView[i];
                    [photos addObject:photo];
                }
                browser.photos = photos;
                
                // 3.设置默认显示的图片索引
                browser.currentPhotoIndex = path.item;
                
                // 3.显示浏览器
                [browser show];
                
            };
        }
        
        return cell;
    }else{
        
        // 创建首页cell
        
        CPHomeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPHomeStatusCell identifier]];
    
    
        cell.status = self.taPubStatus[indexPath.row];
        
        //绑定tag
        cell.myPlay.tag = indexPath.row;
        
        
        // 弹出图片浏览器
        if (cell.pictureDidSelected == nil) {
            cell.pictureDidSelected = ^(CPHomeStatus *status,NSIndexPath *path, NSArray *srcView){
                
                
                // 1.创建图片浏览器
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                NSArray *urls = [status.cover valueForKeyPath:@"original_pic"];
                // 2.设置图片浏览器显示的所有图片
                NSMutableArray *photos = [NSMutableArray array];
                NSUInteger count = urls.count;
                for (int i = 0; i<count; i++) {
                    
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    // 设置图片的路径
                    photo.url = [NSURL URLWithString:urls[i]];
                    // 设置来源于哪一个UIImageView
                    photo.srcImageView = srcView[i];
                    [photos addObject:photo];
                }
                browser.photos = photos;
                
                // 3.设置默认显示的图片索引
                browser.currentPhotoIndex = path.item;
                
                // 3.显示浏览器
                [browser show];
                
            };
        }
        
        //弹出成员列表 防止单元格重用 先判断
        if (cell.tapIcons == nil) {
            __weak typeof(self) weakSelf = self;
            cell.tapIcons = ^(CPHomeStatus *status) {
                [SVProgressHUD showWithStatus:@"努力加载中"];
                //登录状态下可点 拿出创建者字段,非登录 自动跳转登录界面
                NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/info",status.activityId];
                SQLog(@"%@",status.activityId);
                [CPNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
                    [weakSelf disMiss];
                    if ([responseObject operationSuccess]) {
                        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                        NSString *strOrganizer = [formatter stringFromNumber:responseObject[@"data"][@"isOrganizer"]];
                        if ([strOrganizer isEqualToString:@"1"]) {
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
                            
                            MembersManageController * vc = sb.instantiateInitialViewController;
                            vc.activityId = status.activityId;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                            
                        } else  {
                            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
                            MembersController * vc = sb.instantiateInitialViewController;
                            vc.activityId = status.activityId;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }
                        
                    } else {
                        [self.view alertError:responseObject];
                    }
                } failure:^(NSError *error) {
                    [self.view alertError:error];
                }];
                
                
            };
        }
        
        return cell;
    }
    
}




// 计算cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取出对应行模型
    CPTaPublishStatus *status = self.taPubStatus[indexPath.row];
    
    // 先从缓存中获取高度，没有才计算
    if ([self.threeStates isEqualToString:@"post"]) {
        NSNumber *rowHeight = [self.rowHeightCache objectForKey:status.activityId];
        CGFloat cellHeight = [rowHeight doubleValue];
        
        if (rowHeight == nil) {
            
            // 取出cell
            CPTaPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPTaPublishCell identifier]];
            
            // 获取高度
            cellHeight = [cell cellHeightWithTaPublishStatus:status];
            
            // 缓存每一行的高度
            [self.rowHeightCache setObject:@(cellHeight) forKey:status.activityId];
        }
        
        // 设置高度
        return cellHeight;

    }else{
        
        NSNumber *rowHeight = [self.otherRowHeightCache objectForKey:status.activityId];
        CGFloat cellHeight = [rowHeight doubleValue];
        
        if (rowHeight == nil) {
            
            // 取出cell
            CPHomeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPHomeStatusCell identifier]];
            
            CPHomeStatus *homeStatus = [[CPHomeStatus alloc] init];
            homeStatus.activityId = status.activityId;
            homeStatus.introduction = status.introduction;
            homeStatus.publishTime = status.publishTime;
            homeStatus.start = status.start;
            homeStatus.location = status.location;
            homeStatus.totalSeat = status.totalSeat;
            homeStatus.holdingSeat = status.holdingSeat;
            homeStatus.pay = status.pay;
            homeStatus.type = status.type;
            homeStatus.isOrganizer = status.isOrganizer;
            homeStatus.isMember = status.isMember;
            homeStatus.organizer = status.organizer;
            homeStatus.cover = status.cover;
            homeStatus.members = status.members;

            // 获取高度
            cellHeight = [cell cellHeightWithStatus:homeStatus];
            
            // 缓存每一行的高度
            [self.otherRowHeightCache setObject:@(cellHeight) forKey:status.activityId];
        }
        
        // 设置高度
        return cellHeight;

    }
    
}


// 点击cell跳转界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.threeStates isEqualToString:@"post"]) {
        // 获取活动详情storyboard中的控制器
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil];
        CPActiveDetailsController *ac = sb.instantiateInitialViewController;
        
        // 取出对应行模型
        CPTaPublishStatus *status = self.taPubStatus[indexPath.row];
        
        ac.activeId = status.activityId;
        
        [self.navigationController pushViewController:ac animated:YES];
    }
    else{
        // 获取活动详情storyboard中的控制器
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil];
        CPActiveDetailsController *ac = sb.instantiateInitialViewController;
        
        // 取出对应行模型
        CPHomeStatus *status = self.taPubStatus[indexPath.row];
        
        ac.activeId = status.activityId;
        
        [self.navigationController pushViewController:ac animated:YES];
    }
    
    
}

// 点击头像跳转
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    if ([eventName isEqualToString:@"IconClick"]) {
        CPHomeStatus *status = userInfo[@"status"];
        CPTaDetailsController *taDetailsController = [[UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil] instantiateInitialViewController];
        taDetailsController.targetUserId = status.organizer.userId;
        [self.navigationController pushViewController:taDetailsController animated:YES];
        
    }
}



// 预估每一行cell的高度，可提高性能（只计算可是区域的cell）
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 200;
//}
- (IBAction)goToPlay:(UIButton *)sender {
//    [SVProgressHUD showWithStatus:@"努力加载中"];
    CPTaPublishStatus *model = self.taPubStatus[sender.tag];
    NSString *activeId = model.activityId;
    self.activeId = activeId;
    //登录状态下可点 拿出创建者字段,非登录 自动跳转登录界面
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/info",self.activeId];
    [CPNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self disMiss];
        if ([responseObject operationSuccess]) {
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
                if ([strMember isEqualToString:@"2"]) {
                    [self.view alert:@"之前已申请过参加该活动,请勿重复申请"];
                    return ;
                }
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
                            self.carCover = cover;
                            cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                            [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
                            cover.frame = [UIScreen mainScreen].bounds;
                            [self.view.window addSubview:cover];
                            UIView *carView = [[[NSBundle mainBundle]loadNibNamed:@"offerCar" owner:self options:nil]lastObject];
                            CGFloat carViewX = self.view.window.center.x;
                            CGFloat carViewY = self.view.window.center.y - 100;
                            carView.center = CGPointMake(carViewX, carViewY);
                            self.carView = carView;
                            [cover addSubview:carView];
                            //注意加载之后才有xib
                            UIButton *noButton = (UIButton *)[carView viewWithTag:1000];
                            self.noButton = noButton;
                            UIButton *yeButton = (UIButton *)[carView viewWithTag:2000];
                            self.yesButton = yeButton;
                            [noButton addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
                            [yeButton addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
                            CPModelButton * offerButton = (CPModelButton *)[carView viewWithTag:3000];
                            offerButton.button = sender;
                            UITextField * carxibTextFeild = (UITextField *)[carView viewWithTag:4000];
                            self.carxibTextFeild = carxibTextFeild;
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
                            [carView addGestureRecognizer:tap];
                            [offerButton addTarget:self action:@selector(offerSeatButton:) forControlEvents:UIControlEventTouchUpInside];
                            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                            int maxSeat = [[formatter stringFromNumber:responseObject[@"data"][@"maxValue"]] intValue];
                            int minSeat = [[formatter stringFromNumber:responseObject[@"data"][@"minValue"]] intValue];
                            [self.pickerArray removeAllObjects];
                            for (int i = minSeat; i <= maxSeat; i++) {
                                NSString *seat = [NSString stringWithFormat:@"%tu",i];
                                [self.pickerArray addObject:seat];
                            }
                            ZHPickView *picker = [[ZHPickView alloc]initPickviewWithArray:self.pickerArray isHaveNavControler:NO];
                            picker.delegate = self;
                            self.picker = picker;
                            self.carxibTextFeild.font = [AppAppearance textMediumFont];
                            self.carxibTextFeild.textColor = [AppAppearance textDarkColor];
                            
                        } else {
                            NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/join",self.activeId];
                            [CPNetWorkTool postJsonWithUrl:urlStr params:nil success:^(id responseObject) {
                                if ([responseObject operationSuccess]) {
                                    [self.view alert:@"请求成功,等待同意"];
                                    [sender setTitle:@"申请中" forState:UIControlStateNormal];
                                    [sender setBackgroundColor:[Tools getColor:@"ccd1d9"]];
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

//点击提交
- (void)offerSeatButton:(CPModelButton *)btn {
    
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
            [btn.button setTitle:@"申请中" forState:UIControlStateNormal];
            [btn.button setBackgroundColor:[Tools getColor:@"ccd1d9"]];
        } else {
            [self.view alertError:responseObject];
        }
    } failed:^(NSError *error) {
        [self.view alertError:error];
    }];
    
}

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    self.carxibTextFeild.text = resultString;
}

- (void)tap{
    if (!self.tapYes) {
        [self.picker show];
        self.picker.y = kScreenHeight - 256;
        self.yesButton.selected = YES;
        self.noButton.selected = NO;
        self.tapYes = YES;
    } else {
        [self.picker remove];
        self.yesButton.selected = NO;
        self.noButton.selected = YES;
        self.tapYes = NO;
        self.carxibTextFeild.text = nil;
    }
    
}
- (void)dealloc
{
    [CPNotificationCenter removeObserver:self];
    if (self.picker) {
        [self.picker removeFromSuperview];
    }
}

- (void)coverClick {
    [_carCover removeFromSuperview];
    _carCover = nil;
    
    [_carView removeFromSuperview];
    _carView = nil;
    [_picker removeFromSuperview];
    _picker = nil;
    
}
#pragma mark - lazy(懒加载)

- (NSCache *)rowHeightCache{
    if (!_rowHeightCache) {
        _rowHeightCache = [[NSCache alloc] init];
    }
    return _rowHeightCache;
}
- (NSMutableArray *)pickerArray {
    if (!_pickerArray) {
        _pickerArray = [[NSMutableArray alloc]init];
    }
    return _pickerArray;
}
// 用户userId
- (NSString *)userId
{
    _userId = [Tools getValueFromKey:@"userId"];
    return _userId;
}

// 用户token
- (NSString *)token{
    _token = [Tools getValueFromKey:@"token"];
    return _token;
}

// 他的详情数据
- (NSMutableArray *)taPubStatus{
    if (!_taPubStatus) {
        _taPubStatus = [NSMutableArray array];
    }
    return _taPubStatus;
}

// 三种状态
- (NSString *)threeStates{
    if (!_threeStates) {
        _threeStates = @"post";
    }
    return _threeStates;
}

@end
