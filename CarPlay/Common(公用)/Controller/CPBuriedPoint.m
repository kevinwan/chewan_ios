//
//  CPBuriedPoint.m
//  CarPlay
//
//  Created by jiang on 15/11/25.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPBuriedPoint.h"

@implementation CPBuriedPoint
- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        [self resetCount];
        OSVersions = [[UIDevice currentDevice] systemVersion];
    }
    return self;
}
+ (CPBuriedPoint *)sharedBuriedPoint
{
    static CPBuriedPoint *sharedBuriedPoint = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedBuriedPoint = [[CPBuriedPoint alloc]init];
    });
    return sharedBuriedPoint;
}
- (void)resetCount
{
    unRegisterNearbyInvited = 0;
    unRegisterMatchInvited  = 0;
    userRegister = 0;
    activityDynamicCall =0 ;
    activityDynamicChat =0;
    activityTypeClick =0;
    activityMatchInvitedCount =0;
    officialActivityBuyTicket=0;
    officialActivityChatJoin=0;
    appOpenCount=0;
    dynamicNearbyInvited=0;
    unRegisterDynamicAccept=0;
    dynamicAcceptRegister=0;
}
- (void)postBuriedPoint
{
    
    NSDictionary *paramsDic  = [NSDictionary dictionaryWithObjectsAndKeys:OSVersions,@"os",
                          [NSNumber numberWithInteger:unRegisterNearbyInvited],@"unRegisterNearbyInvited",
                          [NSNumber numberWithInteger:unRegisterMatchInvited],@"unRegisterMatchInvited",
                          [NSNumber numberWithInteger:userRegister],@"userRegister",
//                          [NSNumber numberWithInteger:activityDynamicCall],@"activityDynamicCall",
//                          [NSNumber numberWithInteger:activityDynamicChat],@"activityDynamicChat",
//                          [NSNumber numberWithInteger:activityTypeClick],@"activityTypeClick",
//                          [NSNumber numberWithInteger:activityMatchInvitedCount],@"activityMatchInvitedCount",
//                          [NSNumber numberWithInteger:officialActivityBuyTicket],@"officialActivityBuyTicket",
//                          [NSNumber numberWithInteger:officialActivityChatJoin],@"officialActivityChatJoin",
                          [NSNumber numberWithInteger:appOpenCount],@"appOpenCount",
//                          [NSNumber numberWithInteger:dynamicNearbyInvited],@"dynamicNearbyInvited",
//                          [NSNumber numberWithInteger:unRegisterDynamicAccept],@"unRegisterDynamicAccept",
//                          [NSNumber numberWithInteger:dynamicAcceptRegister],@"dynamicAcceptRegister",
                          nil];
    
 [ZYNetWorkTool postJsonWithUrl:[NSString stringWithFormat:@"record/upload?userId=%@",CPUserId] params:paramsDic success:^(id responseObject) {
     NSLog(@"成功，删除本地数据-----= %@",responseObject);
     [self resetCount];
 } failed:^(NSError *error) {
     NSLog(@"失败=====error= %@",error);
 }];
    
}
- (void)unRegisterNearbyInvitedMethod
{
    if (!CPIsLogin) {
        unRegisterNearbyInvited ++;
    }
}
- (void)unRegisterMatchInvitedMethod
{
    if (!CPIsLogin) {
        unRegisterMatchInvited ++;
    }
}
- (void)userRegisterMethod
{
    userRegister++;
}
- (void)activityDynamicCallMethod
{
    activityDynamicCall++;
}
- (void)activityDynamicChatMethod
{
    activityDynamicChat++;
}
- (void)activityTypeClickMethod
{
    activityTypeClick++;
}
- (void)activityMatchInvitedCountMethod
{
    activityMatchInvitedCount++;
}
- (void)officialActivityBuyTicketMethod
{
    officialActivityBuyTicket++;
}
- (void)officialActivityChatJoinMethod
{
    officialActivityChatJoin++;
}
- (void)appOpenCountMethod
{
    appOpenCount++;
}
- (void)dynamicNearbyInvitedMethod
{
    dynamicNearbyInvited++;
}
- (void)unRegisterDynamicAcceptMethod
{
    unRegisterDynamicAccept++;
}
- (void)dynamicAcceptRegisterMethod
{
    dynamicAcceptRegister++;
}






@end
