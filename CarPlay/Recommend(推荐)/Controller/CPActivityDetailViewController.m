//
//  CPActivityDetailViewController.m
//  CarPlay
//
//  Created by chewan on 10/10/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityDetailViewController.h"
#import "CPRecommendModel.h"
#import "CPActivityDetailHeaderView.h"
#import "CPActivityDetailFooterView.h"
#import "CPActivityPartnerCell.h"
#import "CPActivityPathCell.h"
#import "CPTaInfo.h"
#import "ChatViewController.h"
#import "CPByTicketViewController.h"
#import "CPComeOnTipView.h"

#define CPMemberPageNum 6
#define CPWillGoLoginKey @"CPWillGoLoginKey"
@interface CPActivityDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CPActivityDetailFooterView *footerView;
@property (strong, nonatomic) CPActivityDetailHeaderView *headerView;
@property (nonatomic, strong) CPRecommendModel *model;
@property (nonatomic, strong) NSMutableArray<CPPartMember *> *members;
@property (nonatomic, assign) CGFloat activityPathHeight;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSUInteger showMerberCount;
@property (nonatomic, strong) UIButton *comePartButton;
@property (nonatomic, strong) UIButton *byTheTicketButton;
@property (nonatomic, strong) UIButton *toGroupChatButton;
@end

static NSString *ID = @"partCell";
@implementation CPActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    self.tableView.contentInsetBottom = 46;
    [self.view addSubview:self.comePartButton];
    [self.view addSubview:self.byTheTicketButton];
    [self.view addSubview:self.toGroupChatButton];
    
    self.comePartButton.x = 0;
    self.comePartButton.y = self.view.height - 44;
    self.comePartButton.height = 44;
    self.comePartButton.width = ZYScreenWidth;
    
    self.byTheTicketButton.width = ZYScreenWidth * 0.5;
    self.byTheTicketButton.x = 0;
    self.byTheTicketButton.y = self.comePartButton.y;
    self.byTheTicketButton.height = 44;
    
    self.toGroupChatButton.x = ZYScreenWidth * 0.5;
    self.toGroupChatButton.y = self.comePartButton.y;
    self.toGroupChatButton.width = ZYScreenWidth * 0.5;
    self.toGroupChatButton.height = 44;
    self.tableView.backgroundColor = [Tools getColor:@"f7f7f7"];
    self.title = @"活动详情";
    [self loadData];
    ZYWeakSelf
    [[ZYNotificationCenter rac_addObserverForName:CPInvitedSuccessKey object:nil] subscribeNext:^(id x) {
        ZYStrongSelf
        [self.tableView reloadData];
    }];
    
    // 切换登录时返回根视图
    [[ZYNotificationCenter rac_addObserverForName:NOTIFICATION_HASLOGIN object:nil] subscribeNext:^(id x) {
        ZYStrongSelf
        [self loadData];
    }];
}

- (void)loadData
{
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"official/activity/%@/info",self.officialActivityId];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = CPUserId;
    param[@"token"] = CPToken;
    if (CPUnLogin) {
        param = nil;
    }
    [ZYNetWorkTool getWithUrl:url params:param success:^(id responseObject) {
        if (CPSuccess) {
            
            self.model = [CPRecommendModel objectWithKeyValues:responseObject[@"data"]];
            [self reloadData];
            [self loadMembersWithIgnore:0];
        }else{
            [self showInfo:CPErrorMsg];
        }
        
    } failure:^(NSError *error) {
        [self showInfo:@"加载失败"];
    }];
    
}

- (void)loadMembersWithIgnore:(NSInteger)ignore
{
    NSString *url = [NSString stringWithFormat:@"official/activity/%@/members", self.officialActivityId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CPUserId.trimLength) {
        params[UserId] = CPUserId;
    }
    if (CPToken.trimLength) {
        params[Token] = CPToken;
    }
    params[@"ignore"] = @(ignore);
    params[@"limit"] = @(CPMemberPageNum);
    [ZYNetWorkTool getWithUrl:url params:params success:^(id responseObject) {
        DLog(@"%@",responseObject[@"data"]);
        if (CPSuccess) {
            if (ignore == 0) {
                [self.members removeAllObjects];
            }
            self.model.isMember = [responseObject[@"data"][@"isMember"] integerValue];
            NSArray *arr = [CPPartMember objectArrayWithKeyValuesArray:responseObject[@"data"][@"members"]];
            [self.members addObjectsFromArray:arr];
            [self.tableView reloadData];
            [self disMiss];
        }else{
            [self showInfo:CPErrorMsg];
        }
    } failure:^(NSError *error) {
        
        [self showInfo:@"加载失败"];
    }];
}

- (void)reloadData
{
    self.headerView.model = self.model;
    self.tableView.tableHeaderView = self.headerView;
    self.footerView.model = self.model;
    self.footerView.officialActivityId = self.officialActivityId;
    self.tableView.tableFooterView = self.footerView;
    
    // 根据状态切换按钮
    if (_model.isMember){
        if (_model.price) {
            self.comePartButton.hidden = YES;
            self.byTheTicketButton.hidden = NO;
            self.toGroupChatButton.hidden = NO;
        }else{
            self.comePartButton.hidden = NO;
            [self.comePartButton setTitle:@"进入群聊" forState:UIControlStateNormal];
            [self.comePartButton setBackgroundColor:[Tools getColor:@"F48C60"]];
            self.byTheTicketButton.hidden = YES;
            self.toGroupChatButton.hidden = YES;
        }
    }else{
        self.comePartButton.hidden = NO;
        [self.comePartButton setTitle:@"报名参加" forState:UIControlStateNormal];
        [self.comePartButton setBackgroundColor:RedColor];
        self.byTheTicketButton.hidden = YES;
        self.toGroupChatButton.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - 事件交互
- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if ([notifyName isEqualToString:CPActivityDetailHeaderDetailOpenKey]){
        self.tableView.tableHeaderView = self.headerView;
    }else if ([notifyName isEqualToString:CPActivityFooterViewOpenKey]){
        self.tableView.tableFooterView = self.footerView;
    }else if ([notifyName isEqualToString:CPActivityDetailLoadMoreKey]){
        
        if (self.members.count % CPMemberPageNum == 0) {
            
            self.showMerberCount += CPMemberPageNum;
            [self loadMembersWithIgnore:self.showMerberCount];
        }else{
            [self showInfo:@"已无更多数据"];
        }
    }else if ([notifyName isEqualToString:CPClickUserIcon]){
        CPGoLogin(@"查看TA的详情");
        CPTaInfo *taVc = [UIStoryboard storyboardWithName:@"TaInfo" bundle:nil].instantiateInitialViewController;
        taVc.userId = userInfo;
        [self.navigationController pushViewController:taVc animated:YES];
    }else if ([notifyName isEqualToString:CPOfficeActivityMsgButtonClick]){
        CPPartMember *meber = userInfo;
        
        ChatViewController *xiaoniuChatVc = [[ChatViewController alloc]initWithChatter:[Tools md5EncryptWithString:meber.userId] conversationType:eConversationTypeChat];
        xiaoniuChatVc.title = meber.nickname;
        [self.navigationController pushViewController:xiaoniuChatVc animated:YES];
    }else if ([notifyName isEqualToString:CPOfficeActivityPhoneButtonClick]){
        CPPartMember *meber = userInfo;
        //电话
        
        [ZYUserDefaults setObject:meber.avatar forKey:kReceiverHeadUrl];
        [ZYUserDefaults setObject: meber.nickname forKey:kReceiverNickName];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":[Tools md5EncryptWithString:meber.userId], @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
    }else if ([notifyName isEqualToString:CPJionOfficeActivityKey]){
        [self loadData];
    }else if ([notifyName isEqualToString:CPGroupChatClickKey]){
        
        ChatViewController *  chatController = [[ChatViewController alloc] initWithChatter:_model.emchatGroupId
                                                                          conversationType:eConversationTypeGroupChat];
        chatController.title = _model.title;
        [self.navigationController pushViewController:chatController animated:YES];
    }else if ([notifyName isEqualToString:CPGoByTicketClickKey]){
        
        CPByTicketViewController *byTicketVc = [CPByTicketViewController new];
        byTicketVc.url = _model.linkTicketUrl;
        [self.navigationController pushViewController:byTicketVc animated:YES];
    }else if ([notifyName isEqualToString:CPComeOnBabyClickKey]){
        
        if (_model.isMember) {
            
            [CPComeOnTipView showWithActivityId:_officialActivityId partMemberModel:userInfo];
        }else{
            CPGoLogin(@"邀TA");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"报名参加活动以后才能邀请TA参加活动" delegate:nil cancelButtonTitle:@"再想想" otherButtonTitles:@"报名参加", nil];
            [alertView.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x integerValue] != 0) {
                    
                    [self joinOfficeActivity];
                }
            }];
            [alertView show];
        }
    }
}

/**
 *  报名官方活动
 */
- (void)joinOfficeActivity
{
    CPGoLogin(@"报名官方活动");
    NSString *url = [NSString stringWithFormat:@"official/activity/%@/join?userId=%@&token=%@",self.officialActivityId, CPUserId, CPToken];
    [ZYNetWorkTool postJsonWithUrl:url params:nil success:^(id responseObject) {
        if (CPSuccess) {
            [SVProgressHUD showInfoWithStatus:@"申请成功"];
            [self superViewWillRecive:CPJionOfficeActivityKey info:nil];
        }else{
            [SVProgressHUD showInfoWithStatus:CPErrorMsg];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"申请失败"];
    }];
}

#pragma mark - delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.members[indexPath.row].acceptCount > 0) {
        return 110;
    }else{
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPActivityPartnerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.members[indexPath.row];
    cell.activityId = self.officialActivityId;
    return cell;
    
}


#pragma mark - lazy

- (CPActivityDetailHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView =  [CPActivityDetailHeaderView activityDetailHeaderView];
    }
    return _headerView;
}

- (CPActivityDetailFooterView *)footerView
{
    if (_footerView == nil) {
        _footerView = [CPActivityDetailFooterView activityDetailFooterView];
    }
    return _footerView;
}

#pragma mark - lazy
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (NSMutableArray *)members
{
    if (_members == nil) {
        _members = [[NSMutableArray alloc] init];
    }
    return _members;
}

- (UIButton *)comePartButton
{
    if (!_comePartButton) {
        _comePartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comePartButton setBackgroundColor:[Tools getColor:@"fe5967"]];
        [_comePartButton.titleLabel setFont:ZYFont16];
        [_comePartButton setTitle:@"报名参加" forState:UIControlStateNormal];
        [_comePartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ZYWeakSelf
        [[_comePartButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ZYStrongSelf
            CPGoLogin(@"报名参加");
            if ([_comePartButton.currentTitle isEqualToString:@"进入群聊"]) {
                [self superViewWillRecive:CPGroupChatClickKey info:_model];
                return;
            }
            
            NSString *url = [NSString stringWithFormat:@"official/activity/%@/join?userId=%@&token=%@",self.officialActivityId, CPUserId, CPToken];
            [self showLoading];
            [ZYNetWorkTool postJsonWithUrl:url params:nil success:^(id responseObject) {
                if (CPSuccess) {
                    [SVProgressHUD showInfoWithStatus:@"申请成功"];
                    [self superViewWillRecive:CPJionOfficeActivityKey info:nil];
                }else{
                    [SVProgressHUD showInfoWithStatus:CPErrorMsg];
                }
            } failed:^(NSError *error) {
                [SVProgressHUD showInfoWithStatus:@"申请失败"];
            }];
            
        }];
    }
    return _comePartButton;
}

- (UIButton *)byTheTicketButton
{
    if (!_byTheTicketButton) {
        _byTheTicketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _byTheTicketButton.hidden = YES;
        [_byTheTicketButton setBackgroundColor:[Tools getColor:@"1CC1A0"]];
        [_byTheTicketButton.titleLabel setFont:ZYFont16];
        [_byTheTicketButton setTitle:@"前往购票" forState:UIControlStateNormal];
        [_byTheTicketButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ZYWeakSelf
        [[_byTheTicketButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ZYStrongSelf
            CPByTicketViewController *byTicketVc = [CPByTicketViewController new];
            byTicketVc.url = _model.linkTicketUrl;
            [self.navigationController pushViewController:byTicketVc animated:YES];
        }];
    }
    return _byTheTicketButton;
}

- (UIButton *)toGroupChatButton
{
    if (!_toGroupChatButton) {
        _toGroupChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toGroupChatButton.hidden = YES;
        [_toGroupChatButton setBackgroundColor:[Tools getColor:@"F48C60"]];
        [_toGroupChatButton.titleLabel setFont:ZYFont16];
        [_toGroupChatButton setTitle:@"开始群聊" forState:UIControlStateNormal];
        [_toGroupChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ZYWeakSelf
        [[_toGroupChatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            ZYStrongSelf
            ChatViewController *  chatController = [[ChatViewController alloc] initWithChatter:_model.emchatGroupId
                                                                              conversationType:eConversationTypeGroupChat];
            chatController.title = _model.title;
            [self.navigationController pushViewController:chatController animated:YES];
        }];
        
    }
    return _toGroupChatButton;
}


@end
