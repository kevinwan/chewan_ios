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
#import "MJRefreshNormalHeader.h"
#import "CPSelectView.h"

@interface CPNearViewController ()<PagedFlowViewDataSource,PagedFlowViewDelegate>
@property (nonatomic, strong) PagedFlowView *tableView;
@property (nonatomic, strong) NSMutableArray<CPActivityModel *> *datas;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) NSUInteger ignore;
@end
@implementation CPNearViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"筛选" target:self action:@selector(filter)];
    [self.view addSubview:self.tableView];
    [self tipView];
    [self  loadData];
}


/**
 *  加载网络数据
 */
- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[UserId] = CPUserId;
    params[Token] = CPToken;
    double longitude = [ZYUserDefaults doubleForKey:Longitude];
    double latitude = [ZYUserDefaults doubleForKey:Latitude];
    params[@"longitude"] = @(longitude);
    params[@"latitude"] = @(latitude);
    params[@"maxDistance"] = @5000;
//    params[@"ignore"] = @(self.ignore);
    DLog(@"%@",params);
    [ZYNetWorkTool getWithUrl:@"activity/list" params:params success:^(id responseObject) {
        [self.tableView.scrollView.header endRefreshing];
        [self.tableView.scrollView.footer endRefreshing];
        DLog(@"%@ ---- ",responseObject);
        if (CPSuccess) {
            
            if (self.ignore == 0) {
                [self.datas removeAllObjects];
            }
            NSArray *arr = [CPActivityModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datas addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
        [self.tableView.scrollView.header endRefreshing];
        [self.tableView.scrollView.footer endRefreshing];
        NSLog(@"%@",error);
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
        cell.model = self.datas.firstObject;
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
//        [self.tableView reloadData];
    }else if([notifyName isEqualToString:InvitedBtnClickKey]){
        
    }else if([notifyName isEqualToString:IgnoreBtnClickKey]){
        
    }
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
    [CPNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        if (CPSuccess) {
            DLog(@"邀请已发出%@",responseObject);
        }
    } failed:^(NSError *error) {
        DLog(@"%@邀请失败",error);
    }];
    
}

/**
 *  筛选按钮点击
 */
- (void)filter
{
    [CPSelectView showWithParams:^(CPSelectModel *selectModel) {
        NSLog(@"%@",selectModel);
    }];
    
    
}

#pragma mark - 加载子控件

- (PagedFlowView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[PagedFlowView alloc] initWithFrame:({
            CGRectMake(0, 64, ZYScreenWidth, ZYScreenHeight - 84);
        })];
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.orientation = PagedFlowViewOrientationVertical;
        _tableView.backgroundColor = [Tools getColor:@"efefef"];
            _tableView.minimumPageScale = 0.96;
        _tableView.giveFrame = YES;
        ZYWeakSelf
        _tableView.scrollView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            ZYStrongSelf
            self.ignore += CPPageNum;
            [self loadData];
        }];
        
        _tableView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ZYStrongSelf
            self.ignore = 0;
            [self loadData];
        }];
    }
    return _tableView;
}
- (void)test
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.datas addObject:@"jajaj"];
         [self.datas addObject:@"jajaj"];
         [self.datas addObject:@"jajaj"];
         [self.datas addObject:@"jajaj"];
         [self.datas addObject:@"jajaj"];
        [self.tableView reloadData];
        
        [self.tableView.scrollView.footer endRefreshing];
    });
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.25 animations:^{
                        _tipView.alpha = 0;
                    }];
                });
            }
        }];
        [freeTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tipView);
            make.right.equalTo(@-10);
        }];
    }
    return _tipView;
}

@end
