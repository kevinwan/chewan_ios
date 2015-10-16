//
//  CPNearViewController.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNearViewController.h"
#import "CPBaseViewCell.h"
#import "CPMySwitch.h"
#import "CPMyDateViewController.h"
#import "PagedFlowView.h"
#import "CPSelectView.h"
#import "CPNearParams.h"
#import "AAPullToRefresh.h"
#import "ZYProgressView.h"
#import "ZYRefreshView.h"
#import "CPNoDataTipView.h"
#import "CPTaInfo.h"
#import "CPLoadingView.h"

@interface CPNearViewController ()<PagedFlowViewDataSource,PagedFlowViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) PagedFlowView *tableView;
@property (nonatomic, strong) NSMutableArray<CPActivityModel *> *datas;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) NSUInteger ignore;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) CGFloat contentInsetY;
@property (nonatomic, strong) CPNearParams *params;
@property (nonatomic, strong) ZYRefreshView *refreshView;
@property (nonatomic, assign) BOOL isHasRefreshHeader;
@property (nonatomic, strong) CPNoDataTipView *noDataView;
@end
@implementation CPNearViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (CPNoNetWork) {
        
        [ZYProgressView showMessage:@"网络连接失败,请检查网络"];
        return;
    }
    
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"筛选" target:self action:@selector(filter)];
    [self.view addSubview:self.tableView];
    [self tipView];
    [[CPLoadingView sharedInstance] showLoadingView];
    [self loadDataWithHeader:nil];
    DLog(@"%f",self.view.right);
    [RACObserve(self.tableView.scrollView, contentOffset) subscribeNext:^(id x) {
        CGPoint p = [x CGPointValue];
        if (p.y < -40) {
            self.tipView.hidden = NO;
        }else if (p.y > self.tableView.scrollView.height){
            self.tipView.height = YES;
        }
    }];
}

- (void)setUpRefresh
{
    if (self.isHasRefreshHeader) {
        return;
    }
    ZYWeakSelf
    AAPullToRefresh *tv = [_tableView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionTop actionHandler:^(AAPullToRefresh *v){
        NSLog(@"fire from top");
        ZYStrongSelf
        [self.tableView.scrollView setContentOffset:CGPointMake(0, -40) animated:YES];
        self.params.ignore = 0;
        [self loadDataWithHeader:v];
    }];
    tv.imageIcon = [UIImage imageNamed:@"车轮"];
    tv.borderColor = [UIColor whiteColor];
    
    // bottom
    AAPullToRefresh *bv = [_tableView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionBottom actionHandler:^(AAPullToRefresh *v){
        NSLog(@"fire from bottom");
        ZYStrongSelf
        [self.tableView.scrollView setContentOffset:CGPointMake(0, _tableView.scrollView.contentSize.height + 49 - _tableView.scrollView.bounds.size.height) animated:YES];
        
        if (self.datas.count >= CPPageNum) {
            
            self.params.ignore += CPPageNum;
            [self loadDataWithHeader:v];
        }else{
            [v stopIndicatorAnimation];
        }
    }];
    bv.imageIcon = [UIImage imageNamed:@"车轮"];
    bv.borderColor = [UIColor whiteColor];

}

/**
 *  加载网络数据
 */
- (void)loadDataWithHeader:(AAPullToRefresh *)refresh
{

    [ZYNetWorkTool getWithUrl:@"activity/list" params:self.params.keyValues success:^(id responseObject) {
        [[CPLoadingView sharedInstance] dismissLoadingView];
        [self setUpRefresh];
        [refresh stopIndicatorAnimation];
        DLog(@"%@ ---- ",responseObject);
        if (CPSuccess) {
            if (self.ignore == 0) {
                [self.datas removeAllObjects];
            }
            NSArray *arr = [CPActivityModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datas addObjectsFromArray:arr];
            [self.tableView reloadData];
            self.noDataView.tipLabel.text = @"已经没有活动了,请放宽条件再试试";
            self.refreshView.hidden = YES;
            if (self.datas.count == 0) {;
                self.noDataView.hidden = NO;
            }else{
                self.noDataView.hidden = YES;
            }
        }
    } failure:^(NSError *error) {
        
        [self setUpRefresh];
        DLog(@"%@---",error);
        self.ignore -= CPPageNum;
        [refresh stopIndicatorAnimation];
        [self showError:@"加载失败"];
        self.noDataView.tipLabel.text = @"加载失败了,请换个网络试试";
        [[CPLoadingView sharedInstance] dismissLoadingView];
    }];
}


#pragma mark - FlowViewDataSource & FlowViewDelegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(ZYScreenWidth - 20, 383 + self.offset);
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    CPBaseViewCell *cell = (CPBaseViewCell *)[flowView dequeueReusableCell];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CPBaseViewCell" owner:nil options:nil].lastObject;
        cell.model = self.datas[index];
    }
    return cell;
}

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    return self.datas.count;
}

#pragma mark - 事件交互

- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    NSLog(@"%@ %@ ",notifyName, userInfo);
    if ([notifyName isEqualToString:CameraBtnClickKey]) {
        [self cameraPresent];
    }else if([notifyName isEqualToString:PhotoBtnClickKey]){
        [self photoPresent];
    }else if([notifyName isEqualToString:DateBtnClickKey]){
        [self dateClickWithInfo:userInfo];
    }else if([notifyName isEqualToString:InvitedBtnClickKey]){
        
    }else if([notifyName isEqualToString:IgnoreBtnClickKey]){
        
    }else if([notifyName isEqualToString:LoveBtnClickKey]){
        [self loveBtnClickWithInfo:(CPActivityModel *)userInfo];
    }else if ([notifyName isEqualToString:IconViewClickKey]){
        
        CPTaInfo *taVc = [UIStoryboard storyboardWithName:@"TaInfo" bundle:nil].instantiateInitialViewController;
        CPActivityModel *model = userInfo;
        taVc.userId = model.organizer.userId;
        [self.navigationController pushViewController:taVc animated:YES];
    }
}

/**
 *  处理关注点击
 *
 *  @param model model description
 */
- (void)loveBtnClickWithInfo:(CPActivityModel *)model
{
    ZYAsyncThead(^{
        
        for (CPActivityModel *obj in self.datas) {
            if ([obj.organizer.userId isEqualToString:model.organizer.userId]) {
                obj.organizer.subscribeFlag = model.organizer.subscribeFlag;
            }

        }
        ZYMainThread(^{
            
            NSLog(@"===%@",self.datas);
            [self.tableView reloadData];
        });
    });
}

/**
 *  弹出相机
 */
- (void)cameraPresent
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        DLog(@"相机不可用");
        return;
    }
    UIImagePickerController *pic = [UIImagePickerController new];
    pic.sourceType = UIImagePickerControllerSourceTypeCamera;
    [pic.rac_imageSelectedSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }completed:^{
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    [self presentViewController:pic animated:YES completion:NULL];
}

/**
 *  相册弹出
 */
- (void)photoPresent
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        DLog(@"相册不可用");
        return;
    }
    UIImagePickerController *pic = [UIImagePickerController new];
    pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [pic.rac_imageSelectedSignal subscribeNext:^(id x) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } completed:^{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    [self presentViewController:pic animated:YES completion:NULL];

}

/**
 *  处理约她的逻辑
 *
 *  @param userInfo user
 */
- (void)dateClickWithInfo:(id)userInfo
{
    if (CPUnLogin) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还未注册,注册后就可以邀请" delegate:nil cancelButtonTitle:@"再想想" otherButtonTitles:@"去注册", nil];
        [alertView.rac_buttonClickedSignal subscribeNext:^(id x) {
            if ([x integerValue] != 0) {
                [ZYNotificationCenter postNotificationName:NOTIFICATION_GOLOGIN object:nil];
            }
        }];
        [alertView show];
        return;
    }
//    body
//    {
//        “type”:”$type”,
//        “pay”:”$pay”,
//        “destPoint”:
//        {
//            “longitude”:”$longitude”,
//            “latitude”:”$latitude”
//        },
//        “destination”:
//        {
//            “province”:”$province”,
//            “city”:”$city”,
//            “district”:”$district”,
//            “street”:”$street”
//        },
//        “transfer”:”$transfer”
//    }
    CPActivityModel *model = userInfo;
    NSString *url = [NSString stringWithFormat:@"activity/%@/join",model.activityId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[UserId] = CPUserId;
    params[Token] = CPToken;
    DLog(@"邀请%@",params);
    [CPNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        if (CPSuccess) {
            [self showInfo:@"邀请已发出"];
        }else if ([CPErrorMsg contains:@"申请中"]){
            [self showInfo:@"正在申请中"];
        }
    } failed:^(NSError *error) {
        [self showInfo:@"邀请失败"];
    }];
    
}

/**
 *  筛选按钮点击
 */
- (void)filter
{
    [CPSelectView showWithParams:^(CPSelectModel *selectModel) {
        NSLog(@"%@",selectModel.keyValues);
        
        self.params.type = selectModel.type;
        self.params.pay = selectModel.pay;
        [self loadDataWithHeader:nil];
    }];
    
    
}

#pragma mark - 加载子控件

- (PagedFlowView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[PagedFlowView alloc] initWithFrame:({
            CGFloat y = iPhone4?64:84;
            CGRectMake(10, y, ZYScreenWidth - 20, 383 + self.offset);
        })];
        _tableView.backgroundColor = [UIColor clearColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.orientation = PagedFlowViewOrientationVertical;
        self.view.backgroundColor = [Tools getColor:@"efefef"];
        _tableView.minimumPageScale = 0.96;
        // top
        _tableView.scrollView.alwaysBounceVertical = YES;
       
    }
    return _tableView;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (UIView *)tipView
{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = ZYColor(0, 0, 0, 0.7);
        [self.view addSubview:_tipView];
        [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@64);
            make.width.equalTo(self.view);
            make.height.equalTo(@35);
        }];
        
        UILabel *textL = [UILabel labelWithText:@"有空,其他人可以邀请你参加活动" textColor:[UIColor whiteColor] fontSize:14];
        [_tipView addSubview:textL];
        [textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(_tipView);
        }];
        
        CPMySwitch *freeTimeBtn = [CPMySwitch new];
        [freeTimeBtn setOnImage:[UIImage imageNamed:@"btn_youkong"]];
        [freeTimeBtn setOffImage:[UIImage imageNamed:@"btn_meikong"]];
        freeTimeBtn.on = [ZYUserDefaults boolForKey:FreeTimeKey];
        [_tipView addSubview:freeTimeBtn];
        [[freeTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(CPMySwitch *btn) {
            btn.on = !btn.on;
            [ZYUserDefaults setBool:btn.on forKey:FreeTimeKey];
            if (btn.on) {
                textL.text = @"有空,其他人可以邀请你参加活动";
            }else{
                textL.text = @"没空,你将接受不到任何活动邀请";
               
            }
        }];
        [freeTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tipView);
            make.right.equalTo(@-10);
        }];
    } 
    return _tipView;
}

#pragma mark - scrollViewDelegate
//{
//    if (self.refreshing) {
//        return;
//    }
//    if (scrollView.contentOffset.y < -50) {
//        self.contentInsetY = scrollView.contentInset.top;
//        DLog(@"刷仙..");
//        self.refreshing = YES;
//        NSLog(@"%f ..",scrollView.contentOffset.y);
//        self.tableView.scrollView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
//    }
//}
//

- (CPNearParams *)params
{
    if (_params == nil) {
        _params = [[CPNearParams alloc] init];
        _params.userId = CPUserId;
        _params.token = CPToken;
        _params.longitude = ZYLongitude;
        _params.latitude = ZYLatitude;
        _params.ignore = self.ignore;
        _params.maxDistance = 5000;
    }
    return _params;
}


- (ZYRefreshView *)refreshView
{
    if (_refreshView == nil) {
        _refreshView = [[ZYRefreshView alloc] init];
        _refreshView.backgroundColor = [UIColor redColor];
        _refreshView.y = 64;
        _refreshView.x = 0;
        _refreshView.width = ZYScreenWidth;
        _refreshView.height = ZYScreenHeight - 64 - 49;
        [ZYKeyWindow addSubview:_refreshView];
    }
    return _refreshView;
}

- (CPNoDataTipView *)noDataView
{    if (_noDataView == nil) {
        _noDataView = [CPNoDataTipView noDataTipView];
        [self.tableView addSubview:_noDataView];
        _noDataView.frame = self.tableView.bounds;
    }
    return _noDataView;
}

@end
