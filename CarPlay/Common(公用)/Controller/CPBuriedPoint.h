//
//  CPBuriedPoint.h
//  CarPlay
//
//  Created by jiang on 15/11/25.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPBuriedPoint : NSObject
{
    NSInteger unRegisterNearbyInvited;
    NSInteger unRegisterMatchInvited;
    NSInteger userRegister;
    NSInteger activityDynamicCall;
    NSInteger activityDynamicChat;
    NSInteger activityTypeClick;
    NSInteger activityMatchInvitedCount;
    NSInteger officialActivityBuyTicket;
    NSInteger officialActivityChatJoin;
    NSInteger appOpenCount;
    NSInteger dynamicNearbyInvited;
    NSInteger unRegisterDynamicAccept;
    NSInteger dynamicAcceptRegister;
    //系统版本号
    NSString *OSVersions;
}
/*
 发送请求
 */
- (void)postBuriedPoint;

/*
 单例模式
 */
+ (CPBuriedPoint *)sharedBuriedPoint;

/*
 未注册的用户，附近页，点击邀他，次数统计
 */
- (void)unRegisterNearbyInvitedMethod;

/*
 未注册的用户，匹配活动页，点击邀他，次数统计
 */
- (void)unRegisterMatchInvitedMethod;

/*
 未注册的用户，点击注册按钮
 */
- (void)userRegisterMethod;

/*
 活动动态页面，点击打电话的次数
 */
- (void)activityDynamicCallMethod;

/*
 活动动态页面，点击打聊天的次数
 */
- (void)activityDynamicChatMethod;

/*
 每点击一次活动类型，记录一次(匹配页面)
 */
- (void)activityTypeClickMethod;

/*
 活动匹配页面，点击邀他的次数统计.匹配活动页，点击推荐其他活动“邀Ta”的次数（点击两个活动，只算一次）（B）
 */
- (void)activityMatchInvitedCountMethod;

/*
 点击匹配意向按钮，统计点击次数，匹配活动页，点击“匹配活动”按钮的次数（C）
 */
- (void)activityMatchCountMethod;

/*
 推荐活动详情页，点击“去买票”的次数（C）
 */
- (void)officialActivityBuyTicketMethod;

/*
 推荐活动详情页，点击“进入群聊”的次数（D）
 */
- (void)officialActivityChatJoinMethod;

/*
 打开APP的次数（A）
 */
- (void)appOpenCountMethod;

/*
 动态里附近页，点击“邀Ta”的次数（C）
 */
- (void)dynamicNearbyInvitedMethod;

/*
 活动动态里的“假数据”点击“同意”次数（A）
 */
- (void)unRegisterDynamicAcceptMethod;

/*
 点击“同意”后，点击“立即注册”的次数（B）
 */
- (void)dynamicAcceptRegisterMethod;




@end
