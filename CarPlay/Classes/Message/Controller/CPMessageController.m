//
//  CPMessageController.m
//  CarPlay
//
//  Created by 公平价 on 15/6/19.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMessageController.h"
#import "CPNewMessageController.h"
#import "CPMySubscribeController.h"
#import "CPActivityApplyControllerView.h"
#import "CPSubscribePersonController.h"
#import "CPBadgeView.h"

#import "ChatListCell.h"
#import "NSDate+Category.h"
#import "ChatViewController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "RobotManager.h"
#import "CPChatListCell.h"
#import "CPHomeMsgModel.h"

typedef enum {
    CPMessageOptionMsg, // 新留言消息
    CPMessageOptionActivity // 参与活动信息
}CPMessageOption;

@interface CPMessageController ()<IChatManagerDelegate>
@property (weak, nonatomic) CPBadgeView *leaveNewMsgNumber;

@property (weak, nonatomic)  CPBadgeView *activityApplyNewMsgNumber;
@property (weak, nonatomic) UILabel *leaveMsgLabel;
@property (weak, nonatomic)  UILabel *activityApplyMsgLabel;

@property (nonatomic, strong) NSTimer *timer;


@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (nonatomic, strong) UIView                *networkStateView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation CPMessageController

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
        
        
        CPHomeMsgModel *model = [[CPHomeMsgModel alloc] init];
        model.title = @"新的留言";
        model.icon = @"新的评论";
        model.content = @"暂无留言";
        model.timeStr = @"";
        model.isShowUnread = NO;
        
        CPHomeMsgModel *activityModel = [[CPHomeMsgModel alloc] init];
        activityModel.title = @"活动消息";
        activityModel.icon = @"参与申请";
        activityModel.content = @"暂无消息";
        activityModel.timeStr = @"";
        activityModel.isShowUnread = NO;
        
        [_datas addObject:model];
        [_datas addObject:activityModel];
    }
    return _datas;
}

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:180 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        [self loadData];
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.header = [CPRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    if (CPIsLogin){
        [self timer];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (CPUnLogin){
        return;
    }else{
        if (_timer == nil) {
            [self timer];
        }
    }
    
}

- (void)loadData
{
    if (CPUnLogin) {
        [self.tableView.header endRefreshing];
        return;
    }
    
    NSString *userid = [Tools getValueFromKey:@"userId"];
    NSString *token = [Tools getValueFromKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/message/count?token=%@", userid, token];
    
    [ZYNetWorkTool getWithUrl:url params:nil success:^(id responseObject) {
        DLog(@"%@",responseObject);
        [self.tableView.header endRefreshing];
        if (CPSuccess) {
            NSDictionary *comment = responseObject[@"data"][@"comment"];
            
            NSDictionary *application = responseObject[@"data"][@"application"];
            

            NSUInteger newMsgCount = [comment[@"count"] intValue];
            NSUInteger activityApplyCount = [application[@"count"] intValue];
            
            CPHomeMsgModel *model = self.datas[0];
            if (newMsgCount > 0) {
                model.content = comment[@"content"];
                model.createTime = [comment[@"createTime"] longLongValue];
                model.unreadCount = [NSString stringWithFormat:@"%zd",newMsgCount];
                model.isShowUnread = YES;
            }else{
                model.isShowUnread = NO;
            }
            
            CPHomeMsgModel *activityModel = self.datas[1];
            
            if (activityApplyCount > 0) {
            
                activityModel.content = application[@"content"];
                activityModel.unreadCount = [NSString stringWithFormat:@"%zd",activityApplyCount];
                activityModel.createTime = [application[@"createTime"] longLongValue];
                activityModel.isShowUnread = YES;
            }else{
                activityModel.isShowUnread = NO;
            }
            
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            if (activityApplyCount + newMsgCount > 0) {
                
                self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", activityApplyCount + newMsgCount];
            }else{
                
                self.tabBarItem.badgeValue = nil;
            }
            
        }
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        
                CPActivityApplyControllerView *vc = [UIStoryboard storyboardWithName:@"CPActivityApplyControllerView" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:vc animated:YES];
        
        CPHomeMsgModel *model = self.datas[1];
        model.unreadCount = @"";
        model.isShowUnread = NO;
        model.content = @"暂无消息";
        model.createTime = 0;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else if (indexPath.row == 0){      CPNewMessageController *newMsgVc = [UIStoryboard storyboardWithName:@"CPNewMessageController" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:newMsgVc animated:YES];
        
        CPHomeMsgModel *model = self.datas[0];
        model.unreadCount = @"";
        model.isShowUnread = NO;
        model.content = @"暂无留言";
        model.createTime = 0;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{ // 小🐂的群聊天
        
    }
}

#pragma mark - public

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    [self.tableView reloadData];
//    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

#pragma mark - private

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"网络未连接";
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}


- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"图片";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
                } else {
                    ret = didReceiveText;
                }
            } break;
            case eMessageBodyType_Voice:{
                ret = @"语音";
            } break;
            case eMessageBodyType_Location: {
                ret = @"位置";
            } break;
            case eMessageBodyType_Video: {
                ret = @"视频";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
    return @"http://img0.bdstatic.com/img/image/shouye/jianbihua0525.jpg";
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    return chatter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ChatListCell";
    CPChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    cell.model = self.datas[indexPath.row];
//    if (!cell) {
//        cell = [[CPChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
//    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
