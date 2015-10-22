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
{
    NSInteger corentBtnTag;
}
// 互相关注
@property (nonatomic,strong) NSMutableArray *eachSubscribe;
// 我的关注
@property (nonatomic,strong) NSMutableArray *mySubscribe;
// 关注我的
@property (nonatomic,strong) NSMutableArray *beSubscribed;
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
    // 设置标题
    corentBtnTag=10;
    [self.navigationItem setTitle:@"我的关注"];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.tableView setBackgroundColor:[Tools getColor:@"efefef"]];
}

-(void)viewWillAppear:(BOOL)animated{
    // 加载关注信息
    [self setupMyCare];
}



#pragma mark - 加载网络数据
- (void)setupMyCare{
    // 封装请求参数
    NSString *path=[NSString stringWithFormat:@"user/%@/subscribe?token=%@",CPUserId,CPToken];
    [self showLoading];
    [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
        // 数据加载成功
        if (CPSuccess) {
            // 取出关注数据
            NSArray *mySubscribeDicts = responseObject[@"data"][@"mySubscribe"];
            NSArray *eachSubscribeDicts = responseObject[@"data"][@"eachSubscribe"];
            NSArray *beSubscribedDicts = responseObject[@"data"][@"beSubscribed"];
            // 转为模型数组
            _mySubscribe = [[NSMutableArray alloc]initWithArray:[CPCareUser objectArrayWithKeyValuesArray:mySubscribeDicts]];

            _eachSubscribe = [[NSMutableArray alloc]initWithArray:[CPCareUser objectArrayWithKeyValuesArray:eachSubscribeDicts]];
            
            _beSubscribed = [[NSMutableArray alloc]initWithArray:[CPCareUser objectArrayWithKeyValuesArray:beSubscribedDicts]];
            // 刷新表格
            [self.tableView reloadData];
        }else{
            
        }
        [self disMiss];
        
    } failure:^(NSError *error) {
       [self disMiss];
    }];
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (corentBtnTag) {
        case 10:
            return [_eachSubscribe count];
            break;
        case 20:
            return [_mySubscribe count];
            break;
        case 30:
            return [_beSubscribed count];
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CPMyCareCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPMyCareCell identifier]];
    switch (corentBtnTag) {
        case 10:
            cell.careUser = _eachSubscribe[indexPath.row];
            cell.chatBtn.tag=indexPath.row;
            cell.phoneBtn.tag=indexPath.row;
            cell.subscribeBtn.tag=indexPath.row;
            break;
        case 20:
            cell.careUser = _mySubscribe[indexPath.row];
            [cell.chatBtn setHidden:YES];
            [cell.phoneBtn setHidden:YES];
            [cell.subscribeBtn setBackgroundImage:[UIImage imageNamed:@"我的关注_h"] forState:UIControlStateNormal];
            cell.subscribeBtn.tag=indexPath.row;
            break;
        case 30:
            cell.careUser = _beSubscribed[indexPath.row];
            [cell.chatBtn setHidden:YES];
            [cell.phoneBtn setHidden:YES];
            [cell.subscribeBtn setBackgroundImage:[UIImage imageNamed:@"关注我的"] forState:UIControlStateNormal];
            cell.subscribeBtn.tag=indexPath.row;
            break;
    }
    return cell;
}


- (IBAction)careClick:(UIButton *)btn{
    // 切换按钮颜色
    [self changeColor:btn.tag];
    corentBtnTag=btn.tag;
    [self.tableView reloadData];
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

//打开聊天
- (IBAction)chat:(UIButton *)sender {
    
}
//打开语音
- (IBAction)phone:(UIButton *)sender {
    
}
//关注、取消关注
- (IBAction)subscribe:(UIButton *)sender {
    CPCareUser *careUser=[CPCareUser new];
    NSString *url;
    switch (corentBtnTag) {
        case 10:
            careUser=_eachSubscribe[sender.tag];
            url = [NSString stringWithFormat:@"user/%@/listen?token=%@",CPUserId, CPToken];
            break;
        case 20:
            careUser=_mySubscribe[sender.tag];
            url = [NSString stringWithFormat:@"user/%@/unlisten?token=%@",CPUserId, CPToken];
            break;
        case 30:
            careUser=_beSubscribed[sender.tag];
            url = [NSString stringWithFormat:@"user/%@/listen?token=%@",CPUserId, CPToken];
            break;
        default:
            break;
    }
    
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:careUser.userId,@"targetUserId",CPToken,@"token",nil];
    [self showLoading];
    [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        [self disMiss];
        if (CPSuccess) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            switch (corentBtnTag) {
                case 10:
                    [_eachSubscribe removeObjectAtIndex:sender.tag];
                    break;
                case 20:
                    [_mySubscribe removeObjectAtIndex:sender.tag];
                    break;
                case 30:
                    [_beSubscribed removeObjectAtIndex:sender.tag];
                    break;
                default:
                    break;
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"errmsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
    } failed:^(NSError *error) {
        [self disMiss];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }];
}
@end
