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

typedef enum {
    CPMessageOptionMsg, // 新留言消息
    CPMessageOptionActivity // 参与活动信息
}CPMessageOption;

@interface CPMessageController ()<IChatManagerDelegate>
@property (weak, nonatomic) IBOutlet CPBadgeView *leaveNewMsgNumber;

@property (weak, nonatomic) IBOutlet CPBadgeView *activityApplyNewMsgNumber;
@property (weak, nonatomic) IBOutlet UILabel *leaveMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityApplyMsgLabel;

@property (nonatomic, strong) NSTimer *timer;


@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (nonatomic, strong) UIView                *networkStateView;
@end

@implementation CPMessageController

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
        [self.tableView.header endRefreshing];
        if (CPSuccess) {
            
            NSDictionary *comment = responseObject[@"data"][@"comment"];
            
            NSDictionary *application = responseObject[@"data"][@"application"];
            

            NSUInteger newMsgCount = [comment[@"count"] intValue];
            NSUInteger activityApplyCount = [application[@"count"] intValue];
            if (newMsgCount > 0) {
                self.leaveNewMsgNumber.hidden = NO;
                self.leaveNewMsgNumber.badgeValue = [NSString stringWithFormat:@"%zd",newMsgCount];
                
                self.leaveMsgLabel.text = comment[@"content"];
            }
            
            if (activityApplyCount > 0) {
                self.activityApplyNewMsgNumber.hidden = NO;
                self.activityApplyNewMsgNumber.badgeValue = [NSString stringWithFormat:@"%zd", activityApplyCount];
                NSString *text = [application[@"content"] stringByAppendingString:@"活动"];
                NSAttributedString *activityName = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"48d1d5"]}];
                
                NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithString:@"您已成功加入"];
                [msg appendAttributedString:activityName];
                self.activityApplyMsgLabel.attributedText = msg;
            }
            
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
        
        self.activityApplyNewMsgNumber.badgeValue = @"0";
        self.activityApplyNewMsgNumber.hidden = YES;
        self.activityApplyMsgLabel.text = @"暂无消息";
        
        if (self.leaveNewMsgNumber.badgeValue.integerValue > 0) {
            self.tabBarItem.badgeValue = self.leaveNewMsgNumber.badgeValue;
        }else{
            self.tabBarItem.badgeValue = nil;
        }
        CPActivityApplyControllerView *vc = [UIStoryboard storyboardWithName:@"CPActivityApplyControllerView" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.leaveNewMsgNumber.badgeValue = @"0";
        
        if (self.activityApplyNewMsgNumber.badgeValue.integerValue > 0) {
            self.tabBarItem.badgeValue = self.activityApplyNewMsgNumber.badgeValue;
        }else{
            self.tabBarItem.badgeValue = nil;
        }
        self.leaveNewMsgNumber.hidden = YES;
        self.leaveMsgLabel.text = @"暂无留言";
        CPNewMessageController *newMsgVc = [UIStoryboard storyboardWithName:@"CPNewMessageController" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:newMsgVc animated:YES];
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
    static NSString *ID = @"cell";
    UITableViewCell *cell;
    if (indexPath.row > 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.textLabel.text = @"xingbuxing";
        }
        return cell;
    }else{
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
}

@end
