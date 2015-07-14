//
//  lbNetworkVO.h
//  wqh
//
//  Created by 牛鹏赛 on 15-02-05.
//  Copyright (c) 2015年 dongwangyang. All rights reserved.
//

#import "CPNetWork.h"

@interface CPNetworkVO : CPNetWork
-(instancetype)loginWithusername:(NSString *)username
                             pwd:(NSString *)pwd
                          sucess:(resultBlock)sucess
                            fail:(failWithErrorBlock)fail;

-(instancetype)getIdentifyingCodeWithPhone:(NSString *)phone
                                    sucess:(resultBlock)sucess
                                      fail:(failWithErrorBlock)fail;
-(instancetype)checkIdentifyingCodeWithPhone:(NSString *)phone
                                        code:(NSString *)code
                                      sucess:(resultBlock)sucess
                                        fail:(failWithErrorBlock)fail;

//-(instancetype)getRegistrationWithPhone:(NSString *)phone
//                                 sucess:(resultBlock)sucess
//                                   fail:(failWithErrorBlock)fail;
//
//-(instancetype)exitLoginWithsucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail;
//
//-(instancetype)dishWithuserId:(NSString *)userId
//                          url:(NSString *)url
//                       typeId:(NSString *)typeId
//                       reason:(NSString *)reason
//                        price:(NSString *)price
//                        title:(NSString *)title
//                       images:(NSString *)images
//                       sucess:(resultBlock)sucess
//                         fail:(failWithErrorBlock)fail;
//-(instancetype)getFoodTypesWithUserId:(NSString *)userId
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail;
//
//-(instancetype)getListWithType:(NSString *)type
//                         ftype:(NSString *)ftype
//                    searchName:(NSString *)searchName
//                         limit:(NSString *)limit
//                        offset:(NSString *)offset
//                         paixu:(NSString *)paixu
//                        sucess:(resultBlock)sucess
//                          fail:(failWithErrorBlock)fail;
//-(instancetype)shareThingsWithUserId:(NSString *)userId
//                                imgs:(NSString *)imgs
//                          descript:(NSString *)descript
//                         thingName:(NSString *)thingName
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail;
//
//-(instancetype)getGoodsDetailWithType:(NSString *)type
//                                   gid:(NSString *)gid
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail;
//-(instancetype)savechibuchiWithType:(NSString *)type
//                              conId:(NSString *)conId
//                                  gid:(NSString *)gid
//                              chiorbu:(NSString *)chiorbu
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail;
//
//-(instancetype)collectWithType:(NSString *)type
//                        status:(NSString *)status
//                    costTypeId:(NSString *)costTypeId
//                         conId:(NSString *)conId
//                        sucess:(resultBlock)sucess
//                          fail:(failWithErrorBlock)fail;
//
//-(instancetype)getPinglunsWithType:(NSString *)type
//                    costTypeId:(NSString *)costTypeId
//                         conId:(NSString *)conId
//                        sucess:(resultBlock)sucess
//                          fail:(failWithErrorBlock)fail;
//
//
//-(instancetype)getCollListWithConId:(NSString *)conId
//                            sucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail;
//-(instancetype)getLunBoWithConId:(NSString *)conId
//                     sucess:(resultBlock)sucess
//                        fail:(failWithErrorBlock)fail;
//-(instancetype)sqMianfeiWithConId:(NSString *)conId
//                     gid:(NSString *)gid
//                      sucess:(resultBlock)sucess
//                        fail:(failWithErrorBlock)fail;
//-(instancetype)seeOrSaveWithConId:(NSString *)conId
//                     status:(NSString *)status
//                  sucess:(resultBlock)sucess
//                    fail:(failWithErrorBlock)fail;
//
//-(instancetype)checkNiChengWithConId:(NSString *)conId
//                           name:(NSString *)name
//                           sucess:(resultBlock)sucess
//                             fail:(failWithErrorBlock)fail;
//-(instancetype)getQianDaoWithConId:(NSString *)conId
//                                name:(NSString *)name
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail;
//-(instancetype)qiandaoWithConId:(NSString *)conId
//                           name:(NSString *)name
//                         sucess:(resultBlock)sucess
//                           fail:(failWithErrorBlock)fail;
//-(instancetype)getMineBaoliaoWithConId:(NSString *)conId
//                           gid:(NSString *)gid
//                         sucess:(resultBlock)sucess
//                           fail:(failWithErrorBlock)fail;
//-(instancetype)getMineShaiWuWithConId:(NSString *)conId
//                                   gid:(NSString *)gid
//                                sucess:(resultBlock)sucess
//                                  fail:(failWithErrorBlock)fail;
///*!
// 注册用户
// 
// @param phone    手机号
// @param pwd      密码
// @param validate 验证码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)registeredWithPhone:(NSString *)phone
//                               pwd:(NSString *)pwd
//                          validate:(NSString *)validate
//                            sucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail;
///*!
// 获取用户个人信息
// 
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getUserInfoWithPhone:(NSString *)phone
//                                uid:(NSString *)uid
//                              token:(NSString *)token
//                             search:(NSString *)search
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail;
//
///*!
// 添加好友
// 
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//
//-(instancetype)addFriendsWithPhone:(NSString *)phone
//                                uid:(NSString *)uid
//                              token:(NSString *)token
//                             friend:(NSString *)friend_id
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail;
///*!
// 删除好友
// 
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//
//-(instancetype)deleteFriendsWithPhone:(NSString *)phone
//                               uid:(NSString *)uid
//                             token:(NSString *)token
//                            friend:(NSString *)friend_id
//                            sucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail;
//
///*!
// 回应添加好友信息
// 
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//
//-(instancetype)conformFriendsWithPhone:(NSString *)phone
//                               uid:(NSString *)uid
//                             token:(NSString *)token
//                            friend:(NSString *)friend_id
//                              type:(NSString *)type
//                            sucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail;
///*!
// 修改用户个人信息
// 
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)editUserInfoWithPhone:(NSString *)phone
//                                uid:(NSString *)uid
//                              token:(NSString *)token
//                            content:(NSString *)content
//                               type:(NSString *)type
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail;
///*!
// 修改签名的后的信息
// 
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)reqestSignAlipaysign_data:(NSString *)sign_data
//                         sucess:(resultBlock)sucess
//                           fail:(failWithErrorBlock)fail;
///*!
// 申请分会
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)editUserClubWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                                name:(NSString *)name
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail;
//
///*!
// 退款接口
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)refunedClassWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                            order_id:(NSString *)order_id
//                                type:(NSString *)type
//                                sign:(NSString *)sign
//                                name:(NSString *)name
//                             account:(NSString *)account
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail;
///*!
// 获取我的商圈
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getMyBusinessWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                                limit:(NSString *)limit
//                                 type:(NSString *)type
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail;
//
///*!
// 获取我的课程和公益
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getMyClassOrPublicWithPhone:(NSString *)phone
//                                  uid:(NSString *)uid
//                                token:(NSString *)token
//                                limit:(NSString *)limit
//                                 type:(NSString *)type
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail;
//
///*!
// 获取banner列表
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getbannnerWithPhone:(NSString *)phone
//                               uid:(NSString *)uid
//                             token:(NSString *)token
//                            banner:(NSString *)banner
//                              name:(NSString *)name
//                            sucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail;
//
///*!
// 获取banner单个
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getbannnerSingleWithPhone:(NSString *)phone
//                               uid:(NSString *)uid
//                             token:(NSString *)token
//                            banner:(NSString *)banner
//                              name:(NSString *)name
//                            sucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail;
///*!
// 获取我的收藏
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getMyCollectWithPhone:(NSString *)phone
//                                  uid:(NSString *)uid
//                                token:(NSString *)token
//                                limit:(NSString *)limit
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail;
//
//
///*!
// 上传我的通讯录
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)postMyAdressListWithPhone:(NSString *)phone
//                                     uid:(NSString *)uid
//                                   token:(NSString *)token
//                                contacts:(NSString *)contacts
//                                  sucess:(resultBlock)sucess
//                                    fail:(failWithErrorBlock)fail;
//
///*!
// 下载我的通讯录
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)uploadMyAdressListWithPhone:(NSString *)phone
//                                     uid:(NSString *)uid
//                                   token:(NSString *)token
//                                  sucess:(resultBlock)sucess
//                                    fail:(failWithErrorBlock)fail;
///*!
// 发表供需
// @param mobile   手机号码
// @param title   标题
// @param content   内容
// @param type   1 供 0 需
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)supplyDemandWithPhone:(NSString *)phone
//                                  uid:(NSString *)uid
//                                token:(NSString *)token
//                                title:(NSString *)title
//                              content:(NSString *)content
//                                 type:(NSString *)type
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail;
//
///*!
// 删除供需
// @param mobile   手机号码
// @param title   标题
// @param content   内容
// @param type   1 供 0 需
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)delelteSupplyDemandWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                                businessId:(NSString *)businessId
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail;
//
//
///*!
// 收藏供需
// @param mobile   手机号码
// @param title   标题
// @param content   内容
// @param type   1 供 0 需
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)collectSupplyDemandWithPhone:(NSString *)phone
//                                        uid:(NSString *)uid
//                                      token:(NSString *)token
//                                 businessId:(NSString *)businessId
//                                       type:(NSString *)type
//                                     sucess:(resultBlock)sucess
//                                       fail:(failWithErrorBlock)fail;
//
//
///*!
// 修改供需
// @param mobile   手机号码
// @param title   标题
// @param content   内容
// @param type   1 供 0 需
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)editSupplyDemandWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                               title:(NSString *)title
//                             content:(NSString *)content
//                                type:(NSString *)type
//                          businessId:(NSString *)businessId
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail;
///*!
// 上传用户头像
// 
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)uploadUserHeadIconWithPhone:(NSString *)phone
//                                uid:(NSString *)uid
//                              token:(NSString *)token
//                           encodedImageStr:(NSString *)encodedImageStr
//                                      type:(NSString *)type
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail;
///*!
//申请公司认证
// 
// @param mobile   手机号码
// @param pic      上传图片后的url
// @param address  企业地址
// @param description  企业简介
// @param company_phone  企业电话
// @param industry  行业
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)applyCompanyAuthWithPhone:(NSString *)phone
//                                     uid:(NSString *)uid
//                                   token:(NSString *)token
//                                    name:(NSString *)name
//                                     pic:(NSString *)pic
//                                 address:(NSString *)address
//                             description:(NSString *)description
//                           company_phone:(NSString *)company_phone
//                                industry:(NSString *)industry
//                                  sucess:(resultBlock)sucess
//                                    fail:(failWithErrorBlock)fail;
///*!
// 获取我要上央视列表
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getWangCCTVWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                               limit:(NSString *)limit
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail;
///*!
// 获取爱心公益列表
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getDonationListWithPhone:(NSString *)phone
//                                uid:(NSString *)uid
//                              token:(NSString *)token
//                              limit:(NSString *)limit
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail;
///*!
// 获取商会信息列表
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getArticleListWithPhone:(NSString *)phone
//                                    uid:(NSString *)uid
//                                  token:(NSString *)token
//                                  limit:(NSString *)limit
//                           category_id:(NSString *)category_id
//                                 sucess:(resultBlock)sucess
//                                   fail:(failWithErrorBlock)fail;
///*!
// 获取企业名片列表
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getCompanyListWithPhone:(NSString *)phone
//                                   uid:(NSString *)uid
//                                 token:(NSString *)token
//                                 limit:(NSString *)limit
//                                sucess:(resultBlock)sucess
//                                  fail:(failWithErrorBlock)fail;
///*!
// 捐款
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)donationsWithPhone:(NSString *)phone
//                                   uid:(NSString *)uid
//                                 token:(NSString *)token
//                            donationId:(NSString *)donationId
//                                price:(NSString *)price
//                                sucess:(resultBlock)sucess
//                                  fail:(failWithErrorBlock)fail;
///*!
// 我要上央视报名
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)registrationCCTVWithPhone:(NSString *)phone
//                              uid:(NSString *)uid
//                            token:(NSString *)token
//                             name:(NSString *)name
//                          content:(NSString *)content
//                 contactTelephone:(NSString *)contactTelephone
//                           sucess:(resultBlock)sucess
//                             fail:(failWithErrorBlock)fail;
///*!
// 获取课程列表
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getLessonListWithPhone:(NSString *)phone
//                                   uid:(NSString *)uid
//                                 token:(NSString *)token
//                                 limit:(NSString *)limit
//                           category_id:(NSString *)category_id
//                                sucess:(resultBlock)sucess
//                                  fail:(failWithErrorBlock)fail;
///*!
// 电话号码批量获取用户信息
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getUsersInfoListByPhonesWithPhone:(NSString *)phone
//                                  uid:(NSString *)uid
//                                token:(NSString *)token
//                           phoneArray:(NSString *)phoneArray
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail;
///*!
// 购买课程，获取订单号
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getOrderNumberWithPhone:(NSString *)phone
//                                    uid:(NSString *)uid
//                                  token:(NSString *)token
//                                  lessonId:(NSString *)lessonId
//                                 sucess:(resultBlock)sucess
//                                   fail:(failWithErrorBlock)fail;
///*!
// 课程支付
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getPayWithPhone:(NSString *)phone
//                           uid:(NSString *)uid
//                         token:(NSString *)token
//                      lessonId:(NSString *)lessonId
//                        amount:(NSString *)amount
//                          type:(NSString *)type
//                      order_id:(NSString *)order_id
//                        sucess:(resultBlock)sucess
//                          fail:(failWithErrorBlock)fail;
///*!
// 捐赠支付
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)getPayPublicWithPhone:(NSString *)phone
//                           uid:(NSString *)uid
//                         token:(NSString *)token
//                      publicId:(NSString *)publicId
//                         price:(NSString *)price
//                          type:(NSString *)type
//                      order_id:(NSString *)order_id
//                        sucess:(resultBlock)sucess
//                          fail:(failWithErrorBlock)fail;
//
//
//
///**
// *  发送短信验证码
// *
// *  @param mobile    用户的手机号码
// *  @param sucess 成功
// *  @param fail   失败
// *
// *  @return 结果
// */
//-(instancetype)sendVerificationCodeWithMobile:(NSString *)mobile
//                                sucess:(resultBlock)sucess
//                                  fail:(failWithErrorBlock)fail;
///**
// *  获取版本号
// *
// *  @param act    接口类型 rank为获取版本号
// *  @param sucess
// *  @param fail
// *
// *  @return
// */
//-(instancetype)getVersionwithAct:(NSString *)act
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail;
///**
// *  分享接口
// *
// *  @param act    接口类型 share为发送分享信息
// *  @param sucess 用户token
// *  @param fail   用户token
// *
// *  @return 用户token
// */
//-(instancetype)shareFaceInterTofriendWithact:(NSString *)act
//                                      sucess:(resultBlock)sucess
//                                        fail:(failWithErrorBlock)fail;
//
//
//
///**
// *  2.	采集消息推送绑定用户信息 (李维)（已完成）
// 在调用前，请阅读该流程【推送消息采集接口】：
// 说明：登录成功之后，调用一次此采集接口。
// 
// 1)	服务地址：http://{API_URL}/api/CloudPush/AddPushBindUserLog
// 2)	是否验证token：	是
// 3)	提交方式：Post
// 4)	请求参数说明：
// 参数名	参数类型	最大长度	是否可空	参数说明
// channelId	string 			推送频道
// userDeviceId	string			推送设备
// deviceType	int			推送类型{3:Android 4:IOS}
// */
//
//-(id)AddPushBindUserLogWithChannelId:(NSString*)channelId andUserDeviceId:(NSString*)userDeviceId forSuccess:(successfulBlock)success forFailed:(failWithErrorBlock)fail;
//
//
//
///*!
// 查找群
// @param mobile   手机号码
// @param sucess sucess description
// @param fail   fail description
// 
// @return return value description
// */
//-(instancetype)findGroupWithGroupId:(NSString *)groupId
//                                sucess:(resultBlock)sucess
//                                  fail:(failWithErrorBlock)fail;
//
//-(instancetype)creategroupWithHuanXinGroupId:(NSString *)groupId
//                                andGroupName:(NSString *)name
//                                      sucess:(resultBlock)sucess
//                                        fail:(failWithErrorBlock)fail;
@end
