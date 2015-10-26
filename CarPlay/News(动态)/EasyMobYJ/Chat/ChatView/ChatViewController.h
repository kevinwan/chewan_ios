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

#import <UIKit/UIKit.h>
#import "EMChatManagerDefs.h"

@protocol ChatViewControllerDelegate <NSObject>

- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSString *)nickNameWithChatter:(NSString *)chatter;

@end

@interface ChatViewController : UIViewController
@property (strong, nonatomic, readonly) NSString *chatter;
//特定情况下用来存储对方的昵称和头像（如，官方活动的头像和昵称，服务器没有通过拓展传送，只能自己传送了）
//在cellForRow中，通过HerHeadStr来判断是不是要去本地加载头像
@property (nonatomic,copy)NSString *HerHeadStr;
@property (nonatomic,copy)NSString *HerName;

@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (nonatomic) BOOL isInvisible;
@property (nonatomic, assign) id <ChatViewControllerDelegate> delelgate;
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

- (void)reloadData;

- (void)hideImagePicker;

#pragma mark - sendMessage
-(void)sendTextMessage:(NSString *)textMessage;
-(void)sendImageMessage:(UIImage *)image;
-(void)sendAudioMessage:(EMChatVoice *)voice;
-(void)sendVideoMessage:(EMChatVideo *)video;
-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address;
-(void)addMessage:(EMMessage *)message;
- (EMMessageType)messageType;
@end
