//
//  CPCityController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPCityController.h"
#import "AFNetworking.h"


@interface CPCityController ()<UITableViewDataSource,UITableViewDelegate>

// 存储所有活动数据
@property (nonatomic,strong) NSArray *status;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CPCityController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 加载活动数据
    [self setupLoadStatus];
    
}


// 加载活动数据
- (void)setupLoadStatus{
    
    // 封装请求参数
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"key"] = @"hot";
//    parameters[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
//    parameters[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
//    parameters[@"city"] = @"南京";
//    
//    
//    // 获取网络管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    // 发送请求
//    [manager GET:@"http://cwapi.gongpingjia.com/v1/activity/list" parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
//        // 取出活动数据
//        self.status = responseObject[@"data"];
//        NSLog(@"%@",self.status);
//        
//        // 刷新表格
//        [self.tableView reloadData];
//        
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        //
//    }];
//    
    // 刷新表格
}



#pragma mark - 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
