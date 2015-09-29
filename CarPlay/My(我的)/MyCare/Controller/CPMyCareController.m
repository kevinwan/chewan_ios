//
//  CPMyCareController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyCareController.h"
#import "CPTopButton.h"
#import "MJExtension.h"
#import "CPCareUser.h"
#import "CPMyCareCell.h"

@interface CPMyCareController ()<UITableViewDataSource,UITableViewDelegate>

// 我的关注
@property (nonatomic,strong) NSMutableArray *mySubscribe;

// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;


// 顶部三个关注按钮
@property (weak, nonatomic) IBOutlet CPTopButton *careEachBtn;
@property (weak, nonatomic) IBOutlet CPTopButton *myCareBtn;
@property (weak, nonatomic) IBOutlet CPTopButton *careMeBtn;

// 顶部三个关注按钮点击事件
- (IBAction)careClick:(UIButton *)btn;

// 顶部三个关注按钮下三条线
@property (weak, nonatomic) IBOutlet UIView *oneLine;
@property (weak, nonatomic) IBOutlet UIView *twoLine;
@property (weak, nonatomic) IBOutlet UIView *threeLine;

@end

@implementation CPMyCareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setRightNavigationBarItemWithTitle:@"个人信息" Image:nil highImage:nil target:self action:@selector(gotoMyInfo)];
    
    // 加载关注信息
    [self setupMyCare];
  
}


// 临时跳转
- (void)gotoMyInfo{
    UIViewController *vc = [UIStoryboard storyboardWithName:@"CPMyInfoController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 加载网络数据
- (void)setupMyCare{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = @"399e45a8-9e72-4734-a1e2-25a0229c549c";
    
    NSString *userId = @"5608bc1a0cf2c4f648d9bcd5";
    NSString *getUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com:8080/v2/user/%@/subscribe",userId];
    
    [ZYNetWorkTool getWithUrl:getUrl params:parameters success:^(id responseObject) {
        
        // 数据加载成功
        if (CPSuccess) {
             DLog(@"%@",responseObject[@"data"][@"mySubscribe"]);
            
            // 取出关注数据
            NSArray *mySubscribeDicts = responseObject[@"data"][@"mySubscribe"];
            
            // 转为模型数组
            NSArray *mySubscribeModels = [CPCareUser objectArrayWithKeyValuesArray:mySubscribeDicts];

            // 存储我的关注
            [self.mySubscribe addObjectsFromArray:mySubscribeModels];
            
            // 刷新表格
            [self.tableView reloadData];
            
        }
        
        
    } failure:^(NSError *error) {
        //
    }];
    
    
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mySubscribe.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CPMyCareCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPMyCareCell identifier]];
    cell.careUser = self.mySubscribe[indexPath.row];
    return cell;
}


- (IBAction)careClick:(UIButton *)btn{
    // 切换按钮颜色
    [self changeColor:btn.tag];
}

// 切换颜色
- (void)changeColor:(NSInteger)btnTag{
    
    [self.careEachBtn setTitleColor:[Tools getColor:@"999999"] forState:UIControlStateNormal];
    [self.myCareBtn setTitleColor:[Tools getColor:@"999999"] forState:UIControlStateNormal];
    [self.careMeBtn setTitleColor:[Tools getColor:@"999999"] forState:UIControlStateNormal];
    
    [self.oneLine setBackgroundColor:[Tools getColor:@"efefef"]];
    [self.twoLine setBackgroundColor:[Tools getColor:@"efefef"]];
    [self.threeLine setBackgroundColor:[Tools getColor:@"efefef"]];
    
    if (btnTag == 10) {
        [self.careEachBtn setTitleColor:[Tools getColor:@"fe5969"] forState:UIControlStateNormal];
        [self.oneLine setBackgroundColor:[Tools getColor:@"fe5969"]];
    }else if(btnTag == 20){
       [self.myCareBtn setTitleColor:[Tools getColor:@"fe5969"] forState:UIControlStateNormal];
    [self.twoLine setBackgroundColor:[Tools getColor:@"fe5969"]];
    }else{
        [self.careMeBtn setTitleColor:[Tools getColor:@"fe5969"] forState:UIControlStateNormal];
        [self.threeLine setBackgroundColor:[Tools getColor:@"fe5969"]];
    }
    
}

#pragma mark - 懒加载
- (NSMutableArray *)mySubscribe{
    if (!_mySubscribe) {
        _mySubscribe = [NSMutableArray array];
    }
    return _mySubscribe;
}


@end
