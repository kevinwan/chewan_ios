/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ChatListViewController.h"
#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "RobotManager.h"
#import "UserProfileManager.h"
#import "RobotChatViewController.h"
#import "UIImageView+EMWebCache.h"
#import "CPCareMeViewController.h"
#import "CPVisitorViewController.h"
#import "CPMyInterestViewController.h"
#import "CPMyDateViewController.h"
#import "CPDynamicNearViewController.h"
@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.conversationType == eConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:self.chatter]) {
            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.chatter];
        }
        return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.chatter];
    } else if (self.conversationType == eConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"groupSubject"] || [self.ext objectForKey:@"isPublic"]) {
           return [self.ext objectForKey:@"groupSubject"];
        }
    }
    return self.chatter;
}

@end

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate,ChatViewControllerDelegate>
{
    SDWebImageManager *manager;

}
@property (strong, nonatomic) NSMutableArray        *dataSource;

@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [SDWebImageManager sharedManager];

    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];

//    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self networkStateView];
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self searchController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshDataSource];
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

- (void)removeChatroomConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (conversation.conversationType == eConversationTypeChatRoom) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height) style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xefefef);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ChatListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ChatListCell";
            ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.name = conversation.chatter;
            if (conversation.conversationType == eConversationTypeChat) {
                cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
                cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
            }
            else{
                NSString *imageName = @"groupPublicHeader";
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        cell.name = group.groupSubject;
                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                        break;
                    }
                }
                cell.placeholderImage = [UIImage imageNamed:imageName];
            }
            cell.detailMsg = [weakSelf subTitleMessageByConversation:conversation];
            cell.time = [weakSelf lastMessageTimeByConversation:conversation];
            cell.unreadCount = [weakSelf unreadMessageCountByConversation:conversation];
            if (indexPath.row % 2 == 1) {
                cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
            }else{
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            ChatViewController *chatController;
            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
                chatController = [[RobotChatViewController alloc] initWithChatter:conversation.chatter
                                                                 conversationType:conversation.conversationType];
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
            }else {
                chatController = [[ChatViewController alloc] initWithChatter:conversation.chatter
                                                            conversationType:conversation.conversationType];
                chatController.title = [conversation showName];
            }
            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }];
    }
    
    return _searchController;
}

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
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - private
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

//- (NSMutableArray *)loadDataSource
//{
//
//    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
//
//    NSArray* sorte = [conversations sortedArrayUsingComparator:
//           ^(EMConversation *obj1, EMConversation* obj2){
//               EMMessage *message1 = [obj1 latestMessage];
//               EMMessage *message2 = [obj2 latestMessage];
//               if(message1.timestamp > message2.timestamp) {
//                   return(NSComparisonResult)NSOrderedAscending;
//               }else {
//                   return(NSComparisonResult)NSOrderedDescending;
//               }
//           }];
//    //验证排序问题，把 感兴趣的  放到首位
////    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
//
//
//    NSMutableArray * sortArr = [NSMutableArray arrayWithArray:sorte];
//
////    后续优化算法，暂时这样做先
//        if (sortArr.count == 0) {
//        EMConversation *interestConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"interestadmin" conversationType:eConversationTypeChat];
//        [sortArr addObject:interestConversation];
//    }
//    //感兴趣的
//    for (int i = 0; i<sortArr.count; i++) {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"interestadmin"])
//        {
//            break;
//        }else if (i == sortArr.count-1)
//        {
//            EMConversation *interestConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"interestadmin" conversationType:eConversationTypeChat];
//            [sortArr addObject:interestConversation];
//            break;
//        }
//    }
//    //活动动态
//    for (int i = 0; i<sortArr.count; i++) {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"activitystateadmin"])
//        {
//            break;
//        }else if (i == sortArr.count-1)
//        {
//            EMConversation *interestConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"activitystateadmin" conversationType:eConversationTypeChat];
//            [sortArr addObject:interestConversation];
//            break;
//        }
//    }
//    
//    //最近访客
//    for (int i = 0; i<sortArr.count; i++) {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"userviewadmin"])
//        {
//            break;
//        }else if (i == sortArr.count-1)
//        {
//            EMConversation *interestConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"userviewadmin" conversationType:eConversationTypeChat];
//            [sortArr addObject:interestConversation];
//            break;
//        }
//    }
//    
//    //谁关注我
//    for (int i = 0; i<sortArr.count; i++) {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"subscribeadmin"])
//        {
//            break;
//        }else if (i == sortArr.count-1)
//        {
//            EMConversation *interestConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"subscribeadmin" conversationType:eConversationTypeChat];
//            [sortArr addObject:interestConversation];
//            break;
//        }
//    }
//    
//    //车玩官方
//    for (int i = 0; i<sortArr.count; i++) {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"officialadmin"])
//        {
//            break;
//        }else if (i == sortArr.count-1)
//        {
//            EMConversation *interestConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"officialadmin" conversationType:eConversationTypeChat];
//            [sortArr addObject:interestConversation];
//            break;
//        }
//    }
//
//    
//    
//    
////    for (int i = 0; i<sortArr.count; i++)
////    {
////        EMConversation *conversation = [sortArr objectAtIndex:i];
////        if ([conversation.chatter isEqualToString:@"interestadmin"])
////        {
////            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:0];
////        }else if ([conversation.chatter isEqualToString:@"activitystateadmin"])
////        {
////            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:1];
////        }else if ([conversation.chatter isEqualToString:@"userviewadmin"])
////        {
////            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:2];
////        }else if ([conversation.chatter isEqualToString:@"subscribeadmin"])
////        {
////            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:3];
////        }else if ([conversation.chatter isEqualToString:@"officialadmin"])
////        {
////            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:4];
////        }
////    }
//    //test
//    for (int i = 0; i<sortArr.count; i++)
//    {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"interestadmin"])
//        {
//            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:0];
//        }
//    }
//    for (int i = 0; i<sortArr.count; i++)
//    {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"activitystateadmin"])
//        {
//            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:1];
//        }
//    }
//
//    for (int i = 0; i<sortArr.count; i++)
//    {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"userviewadmin"])
//        {
//            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:2];
//        }
//    }
//
//    for (int i = 0; i<sortArr.count; i++)
//    {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"subscribeadmin"])
//        {
//            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:3];
//        }
//    }
//
//    for (int i = 0; i<sortArr.count; i++)
//    {
//        EMConversation *conversation = [sortArr objectAtIndex:i];
//        if ([conversation.chatter isEqualToString:@"officialadmin"])
//        {
//            [sortArr exchangeObjectAtIndex:i withObjectAtIndex:4];
//        }
//    }
//
//
//    
//    return sortArr;
//}

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
                ret = NSLocalizedString(@"message.image1", @"[image]");
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
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
//    NSLog(@"===========title = %@,indexPath = %ld",conversation.chatter,(long)indexPath.row);
    cell.cpSexView.hidden = YES;
//    cell.name  = @"";
    if (conversation.conversationType == eConversationTypeChat) {
        if ([conversation.chatter isEqualToString:@"interestadmin"]) {
            cell.textLabel.text = @"感兴趣的";
            cell.HeadIV.image = [UIImage imageNamed:@"InterestAdmin"];
            NSURL *url = [NSURL URLWithString:[conversation.latestMessage.ext valueForKey:@"avatar"]];
            [cell.interestIV sd_setImageWithURL:url placeholderImage:nil];
        }
        else if ([conversation.chatter isEqualToString:@"activitystateadmin"])
        {
            cell.textLabel.text = @"活动动态";
            cell.HeadIV.image = [UIImage imageNamed:@"ActivityStateAdmin"];
            
        }else if ([conversation.chatter isEqualToString:@"userviewadmin"])
        {
            cell.textLabel.text = @"最近访客";
            cell.HeadIV.image = [UIImage imageNamed:@"UserViewAdmin"];
            
        }else if ([conversation.chatter isEqualToString:@"subscribeadmin"])
        {
            cell.textLabel.text = @"谁关注我";
            cell.HeadIV.image = [UIImage imageNamed:@"SubscribeAdmin"];
            
        }else if ([conversation.chatter isEqualToString:@"officialadmin"])
        {
            cell.textLabel.text = @"车玩官方";
            cell.HeadIV.image = [UIImage imageNamed:@"OfficialAdmin"];

        }else if ([conversation.chatter isEqualToString:@"nearbyadmin"])
        {
            cell.textLabel.text = @"附近";
            cell.HeadIV.image = [UIImage imageNamed:@"nearbyadmin"];
            
        }else{
        //如果是1v1聊天，展示性别view
            cell.cpSexView.hidden = NO;
            //从我的关注过来的消息，没有头像。
            if (conversation.latestMessageFromOthers.ext == nil) {
                //获取对方的头像和昵称
                [ZYNetWorkTool getWithUrl:[NSString stringWithFormat:@"user/emchatInfo?userId=%@&token=%@&emchatName=%@",CPUserId,CPToken,conversation.chatter] params:nil success:^(id responseObject) {
                    if (CPSuccess) {
                        NSDictionary *dic = [responseObject objectForKey:@"data"];
                        cell.textLabel.text = [dic objectForKey:@"nickname"];
                        cell.cpSexView.age = [[dic objectForKey:@"age"] integerValue];
                        cell.cpSexView.gender = [dic objectForKey:@"gender"];
                        [cell.HeadIV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:nil];
                        NSLog(@"-=-=-=请求回来的昵称是：%@,row = %ld",cell.name,indexPath.row);
                        [self tableView:tableView canEditRowAtIndexPath:indexPath];
                        //cpsexview的位置由名字的长度绝对，距离名字最后一个字10像素，而名字是这里得到的，所以只能在这里重置位置
                        //65是textLabel的x，即是初始值。
                        CGSize size =  [cell.textLabel.text sizeWithFont:cell.textLabel.font maxW:200];
                        cell.cpSexView.x = 65+size.width+10;

                    }
                } failure:^(NSError *error) {
                    ;
                }];

            }else{
                cell.textLabel.text = [conversation.latestMessageFromOthers.ext valueForKey:kUserNickName];
                [cell.HeadIV sd_setImageWithURL:[NSURL URLWithString:[conversation.latestMessageFromOthers.ext valueForKey:kUserHeadUrl]] placeholderImage:nil];
                cell.cpSexView.age = [[conversation.latestMessageFromOthers.ext valueForKey:kUserAge] integerValue];
                cell.cpSexView.gender = [conversation.latestMessageFromOthers.ext valueForKey:KUserSex];
                //cpsexview的位置由名字的长度绝对，距离名字最后一个字10像素，而名字是这里得到的，所以只能在这里重置位置
                //65是textLabel的x，即是初始值。
                CGSize size =  [cell.textLabel.text sizeWithFont:cell.textLabel.font maxW:200];
                cell.cpSexView.x = 65+size.width+10;


            }
            
        }


    }
    else{//群聊

//        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager loadAllMyGroupsFromDatabaseWithAppend2Chat:NO];

        NSLog(@"当下的groupid = %@",conversation.chatter);
        for (EMGroup *group in groupArray) {
            NSLog(@"====group.id = %@",group.groupId);
            if ([group.groupId isEqualToString:conversation.chatter]) {
                //有时候拿不到groupDescription。比如没有人发过消息
                if (NO) {
                    //设置群聊头像
                    NSString *headStr = [group.groupDescription stringByReplacingOccurrencesOfString:@"|" withString:@"/"];
                    NSLog(@"headstr = %@",headStr);

                    NSArray *photos = [headStr componentsSeparatedByString:@";"];
                    NSLog(@"photos = %@",photos);
                    //用；分割以后，比正常数组多了一个空对象，所以下面的case从2开始，后期做优化的时候修改。
                    switch ([photos count]) {
                        case 1:
                            [cell.HeadIV sd_setImageWithURL:[NSURL URLWithString:photos[0]] placeholderImage:nil];
                            break;
                            
                        case 2:
                        {
                            [manager downloadImageWithURL:[NSURL URLWithString:photos[0]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                UIImage *image1 = [UIImage imageWithBgImage:[UIImage imageNamed:@"群头像背景"] waterImage:[self shearToCircleImage:image] frame:CGRectMake(6.5, 16, 17, 17) angle:0];
                                [manager downloadImageWithURL:[NSURL URLWithString:photos[1]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    UIImage *image2 = [UIImage imageWithBgImage:image1 waterImage:[self shearToCircleImage:image] frame:CGRectMake(26.5, 16, 17, 17) angle:0];
                                    [cell.HeadIV setImage:image2];
                                }];
                            }];
                        }
                            
                            break;
                            
                        case 3:
                        {
                            [manager downloadImageWithURL:[NSURL URLWithString:photos[0]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                UIImage *image1 = [UIImage imageWithBgImage:[UIImage imageNamed:@"群头像背景"] waterImage:[self shearToCircleImage:image] frame:CGRectMake(16, 7, 17, 17) angle:0];
                                [manager downloadImageWithURL:[NSURL URLWithString:photos[1]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    UIImage *image2 = [UIImage imageWithBgImage:image1 waterImage:[self shearToCircleImage:image] frame:CGRectMake(6.5, 26, 17, 17) angle:0];
                                    [manager downloadImageWithURL:[NSURL URLWithString:photos[2]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        UIImage *image3 = [UIImage imageWithBgImage:image2 waterImage:[self shearToCircleImage:image] frame:CGRectMake(26.5, 26, 17, 17) angle:0];
                                        [cell.HeadIV setImage:image3];
                                        
                                    }];
                                }];
                            }];
                        }
                            break;
                            
                        case 4:
                        {
                            [manager downloadImageWithURL:[NSURL URLWithString:photos[0]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                UIImage *image1 = [UIImage imageWithBgImage:[UIImage imageNamed:@"群头像背景"] waterImage:[self shearToCircleImage:image] frame:CGRectMake(5, 5, 14, 14) angle:0];
                                [manager downloadImageWithURL:[NSURL URLWithString:photos[1]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    UIImage *image2 = [UIImage imageWithBgImage:image1 waterImage:[self shearToCircleImage:image] frame:CGRectMake(5+14+2, 5, 14, 14) angle:0];
                                    [manager downloadImageWithURL:[NSURL URLWithString:photos[2]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        UIImage *image3 = [UIImage imageWithBgImage:image2 waterImage:[self shearToCircleImage:image] frame:CGRectMake(5, 14+5+2, 14, 14) angle:0];
                                        [manager downloadImageWithURL:[NSURL URLWithString:photos[3]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                            UIImage *image4 = [UIImage imageWithBgImage:image3 waterImage:[self shearToCircleImage:image] frame:CGRectMake(5+14+2, 5+14+2, 14, 14) angle:0];
                                            [cell.HeadIV setImage:image4];
                                        }];
                                    }];
                                }];
                            }];
                        }
                            break;
                    }
                    
                }else{
                    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:conversation.chatter completion:^(EMGroup *group, EMError *error) {
                        //设置群名称
                        cell.textLabel.text = group.groupSubject;

                        //设置群聊头像
                        NSString *headStr = [group.groupDescription stringByReplacingOccurrencesOfString:@"|" withString:@"/"];
                        NSArray *photos = [headStr componentsSeparatedByString:@";"];
                        switch ([photos count]) {
                            case 1:
                                [cell.HeadIV sd_setImageWithURL:[NSURL URLWithString:photos[0]] placeholderImage:nil];
                                break;
                                
                            case 2:
                            {
                                [manager downloadImageWithURL:[NSURL URLWithString:photos[0]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    UIImage *image1 = [UIImage imageWithBgImage:[UIImage imageNamed:@"群头像背景"] waterImage:[self shearToCircleImage:image] frame:CGRectMake(5.5, 14, 14, 14) angle:0];
                                    [manager downloadImageWithURL:[NSURL URLWithString:photos[1]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        UIImage *image2 = [UIImage imageWithBgImage:image1 waterImage:[self shearToCircleImage:image] frame:CGRectMake(5.5+14+2, 14, 14, 14) angle:0];
                                        [cell.HeadIV setImage:image2];
                                    }];
                                }];
                            }
                                
                                break;
                                
                            case 3:
                            {
                                [manager downloadImageWithURL:[NSURL URLWithString:photos[0]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    UIImage *image1 = [UIImage imageWithBgImage:[UIImage imageNamed:@"群头像背景"] waterImage:[self shearToCircleImage:image] frame:CGRectMake(14, 3.5, 14, 14) angle:0];
                                    [manager downloadImageWithURL:[NSURL URLWithString:photos[1]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        UIImage *image2 = [UIImage imageWithBgImage:image1 waterImage:[self shearToCircleImage:image] frame:CGRectMake(6.5, 20, 14, 14) angle:0];
                                        [manager downloadImageWithURL:[NSURL URLWithString:photos[2]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                            UIImage *image3 = [UIImage imageWithBgImage:image2 waterImage:[self shearToCircleImage:image] frame:CGRectMake(23.5, 20, 14, 14) angle:0];
                                            [cell.HeadIV setImage:image3];
                                            
                                        }];
                                    }];
                                }];
                            }
                                break;
                                
                            case 4:
                            {
                                [manager downloadImageWithURL:[NSURL URLWithString:photos[0]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    UIImage *image1 = [UIImage imageWithBgImage:[UIImage imageNamed:@"群头像背景"] waterImage:[self shearToCircleImage:image] frame:CGRectMake(5, 5, 14, 14) angle:0];
                                    [manager downloadImageWithURL:[NSURL URLWithString:photos[1]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        UIImage *image2 = [UIImage imageWithBgImage:image1 waterImage:[self shearToCircleImage:image] frame:CGRectMake(5+14+2, 5, 14, 14) angle:0];
                                        [manager downloadImageWithURL:[NSURL URLWithString:photos[2]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                            UIImage *image3 = [UIImage imageWithBgImage:image2 waterImage:[self shearToCircleImage:image] frame:CGRectMake(5, 14+5+2, 14, 14) angle:0];
                                            [manager downloadImageWithURL:[NSURL URLWithString:photos[3]] options:SDWebImageRetryFailed progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                UIImage *image4 = [UIImage imageWithBgImage:image3 waterImage:[self shearToCircleImage:image] frame:CGRectMake(5+14+2, 5+14+2, 14, 14) angle:0];
                                                [cell.HeadIV setImage:image4];
                                            }];
                                        }];
                                    }];
                                }];
                            }
                                break;
                        }
                        
                        
                    } onQueue:dispatch_get_main_queue()];

                }
                break;//跳出for循环
            }
        }
//        if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
//        {
//            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//            for (EMGroup *group in groupArray) {
//                if ([group.groupId isEqualToString:conversation.chatter]) {
//                    cell.textLabel.text = group.groupSubject;
//                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
//
//                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
//                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
//                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
//                    conversation.ext = ext;
//                    break;
//                }
//            }
//        }
//        else
//        {
//            cell.textLabel.text = [conversation.ext objectForKey:@"groupSubject"];
//            imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
//        }

    }
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    
    if (![conversation.chatter isEqualToString:@"interestadmin"]) {
        cell.time = [self lastMessageTimeByConversation:conversation];
        cell.interestIV.image = nil;
    }else{
        cell.time = nil;
    }

    if (conversation.conversationType == eConversationTypeGroupChat) {
        cell.isGroup = YES;
    }else{
        cell.isGroup = NO;
    }
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
 
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
       ChatViewController *chatController;
    NSString *title = conversation.chatter;
    if (conversation.conversationType != eConversationTypeChat) {
        if ([[conversation.ext objectForKey:@"groupSubject"] length])
        {
            title = [conversation.ext objectForKey:@"groupSubject"];
        }
        else
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    title = group.groupSubject;
                    break;
                }
            }
        }
    }

    //****注意，官方活动的自定义的数据要手动取消未读消息数量****//
    NSString *chatter = conversation.chatter;
    if ([chatter isEqualToString:@"subscribeadmin"]) {
        //关注我的
        CPCareMeViewController *careMeVC = [[CPCareMeViewController alloc]init];
        [self.navigationController pushViewController:careMeVC animated:YES];
        [conversation markAllMessagesAsRead:YES];
    }else if ([chatter isEqualToString:@"userviewadmin"])
    {//最近访客
        CPVisitorViewController *careMeVC = [[CPVisitorViewController alloc]init];
        [self.navigationController pushViewController:careMeVC animated:YES];
        [conversation markAllMessagesAsRead:YES];

    }else if ([chatter isEqualToString:@"interestadmin"])
    {//感兴趣的
        [conversation markAllMessagesAsRead:YES];
        [self.navigationController pushViewController:[CPMyInterestViewController new] animated:YES];
    }else if ([chatter isEqualToString:@"activitystateadmin"])
    {//活动动态
        [conversation markAllMessagesAsRead:YES];
        CPMyDateViewController *myDateVC = [[CPMyDateViewController alloc]init];
        myDateVC.isDynamic = YES;
        [self.navigationController pushViewController:myDateVC animated:YES];
        
        
    }else if ([chatter isEqualToString:@"officialadmin"])
    {//车玩官方
        [conversation markAllMessagesAsRead:YES];
        chatController = [[ChatViewController alloc] initWithChatter:chatter
                                                    conversationType:conversation.conversationType];
        chatController.title = @"车玩官方";
        chatController.HerHeadStr =@"OfficialAdmin";
        chatController.HerName = @"车玩官方";
        chatController.delelgate = self;
        [self.navigationController pushViewController:chatController animated:YES];

        
    }else if ([chatter isEqualToString:@"nearbyadmin"])
    {//附近
        [conversation markAllMessagesAsRead:YES];
        [self.navigationController pushViewController:[CPDynamicNearViewController new] animated:YES];
    }
    else {
        //test 测试群聊
        chatController = [[ChatViewController alloc] initWithChatter:chatter
                                                    conversationType:conversation.conversationType];
        //如果是群聊，进入以后显示的名字是textLabel.text
        if (conversation.conversationType == eConversationTypeGroupChat) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            chatController.title =cell.textLabel.text;

        }else{
        chatController.title = [conversation.latestMessageFromOthers.ext valueForKey:kUserNickName];

        }
        chatController.delelgate = self;
        [self.navigationController pushViewController:chatController animated:YES];

    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(showName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - public

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }

}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}

#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
//    return @"http://img0.bdstatic.com/img/image/shouye/jianbihua0525.jpg";
    return nil;
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    return chatter;
}
-(UIImage *)shearToCircleImage:(UIImage *)image{
    CGFloat sizeW = image.size.width;
    CGFloat sizeH = image.size.height;
    CGSize size =  CGSizeMake(sizeW, sizeH);
    // 创建bit上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    
    // 画出外边的大圆
    CGFloat bigX = sizeW * 0.5;
    CGFloat bigY = sizeH * 0.5;
    CGFloat radius = bigX;
    CGContextAddArc(ctf, bigX, bigY, radius, 0, M_PI * 2, NO);
    
    // 将上下文渲染到图层
    CGContextFillPath(ctf);
    
    // 画小圆
    CGFloat smallX = bigX;
    CGFloat smallY = bigY;
    CGContextAddArc(ctf, smallX, smallY, radius, 0, M_PI * 2, NO);
    CGContextClip(ctf);
    
    // 画图
    [image drawInRect:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    
    // 获得上下文中的图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
