//
//  npsNetworkVO.m
//  wqh
//
//  Created by 牛鹏赛 on 15-02-05.
//  Copyright (c) 2015年 dongwangyang. All rights reserved.
//

#import "CPNetworkVO.h"
@implementation CPNetworkVO

-(instancetype)loginWithusername:(NSString *)username
                             pwd:(NSString *)pwd
                          sucess:(resultBlock)sucess
                            fail:(failWithErrorBlock)fail

{
    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:username,@"phone",pwd,@"password", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_isContactsLogined.action"];
    id client=[self postRequestWithBaseUrl:BASE_URL  andPath:@"/v1/user/login" andParameters:para forSueccessful:^(id responseObject) {
        sucess(responseObject);
    } forFail:^(NSError *error) {
        fail(error);
        }];
    return client;
}

-(instancetype)getIdentifyingCodeWithPhone:(NSString *)phone
                                    sucess:(resultBlock)sucess
                                      fail:(failWithErrorBlock)fail{
    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
    NSString *path=[[NSString alloc]initWithFormat:@"/v1/phone/%@/verification",phone];
    id client=[self getRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSuccessful:^(id responseObject) {
    }forFail:^(NSError *error) {
        fail(error);
    }];
    return client;
}

-(instancetype)checkIdentifyingCodeWithPhone:(NSString *)phone
                                        code:(NSString *)code
                                      sucess:(resultBlock)sucess
                                        fail:(failWithErrorBlock)fail{
    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:code,@"code", phone,@"phone",nil];
    NSString *path=[[NSString alloc]initWithFormat:@"/v1/phone/%@/verification",phone];
    id client=[self postRequestWithBaseUrl:BASE_URL  andPath:path andParameters:para forSueccessful:^(id responseObject) {
        sucess(responseObject);
    } forFail:^(NSError *error) {
        fail(error);
    }];
    return client;
}
//
//-(instancetype)getRegistrationWithPhone:(NSString *)phone
//                                 sucess:(resultBlock)sucess
//                                   fail:(failWithErrorBlock)fail
//{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_getLittleMess.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//         fail(error);
//    }];
//    
//    return client;
//}
//-(instancetype)registeredWithPhone:(NSString *)phone
//                                  pwd:(NSString *)pwd
//                                 validate:(NSString *)validate
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail
//{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",pwd,@"password",validate,@"code", nil];
//     NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_mobileRegistered.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//         fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)dishWithuserId:(NSString *)userId
//                          url:(NSString *)url
//                       typeId:(NSString *)typeId
//                       reason:(NSString *)reason
//                        price:(NSString *)price
//                        title:(NSString *)title
//                       images:(NSString *)images
//                       sucess:(resultBlock)sucess
//                         fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:userId,@"conId",url,@"url",reason,@"reason",price,@"price",title,@"title",images,@"images",typeId,@"typeId", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_saveGoodsFromIos.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getListWithType:(NSString *)type
//                         ftype:(NSString *)ftype
//                    searchName:(NSString *)searchName
//                         limit:(NSString *)limit
//                        offset:(NSString *)offset
//                         paixu:(NSString *)paixu
//                        sucess:(resultBlock)sucess
//                          fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:type,@"gtype",ftype,@"ftype",searchName,@"name",limit,@"limite",offset,@"offset",paixu,@"paixu", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_getList.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getFoodTypesWithUserId:(NSString *)userId
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:userId,@"conId", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_getFoodTypes.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)shareThingsWithUserId:(NSString *)userId
//                                imgs:(NSString *)imgs
//                            descript:(NSString *)descript
//                           thingName:(NSString *)thingName
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:userId,@"conId",imgs,@"images",descript,@"descriptions",thingName,@"title", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_saveSunGoodsFromIos.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getGoodsDetailWithType:(NSString *)type
//                                   gid:(NSString *)gid
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:type,@"ggtype",gid,@"gid", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_getGoodsDetail.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)savechibuchiWithType:(NSString *)type
//                              conId:(NSString *)conId
//                                gid:(NSString *)gid
//                            chiorbu:(NSString *)chiorbu
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:type,@"typeId",gid,@"costTypeId",chiorbu,@"chiorbu",conId,@"conId", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_savechibuchi.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)collectWithType:(NSString *)type
//                        status:(NSString *)status
//                    costTypeId:(NSString *)costTypeId
//                         conId:(NSString *)conId
//                        sucess:(resultBlock)sucess
//                          fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:type,@"typeId",costTypeId,@"costTypeId",status,@"status",conId,@"conId",status,@"status", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_collection.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getPinglunsWithType:(NSString *)type
//                        costTypeId:(NSString *)costTypeId
//                             conId:(NSString *)conId
//                            sucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:type,@"typeId",costTypeId,@"costTypeId",conId,@"conId", nil];
//    NSString *path=[[NSString alloc]initWithFormat:@"/%@%@",PROJECT_NAME,@"/contacts/contacts_getPingluns.action"];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:path andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)registerWithFlag:(NSString *)flag
//                           type:(NSString *)type
//                         typeid:(NSString *)typeid
//                         sucess:(resultBlock)sucess
//                           fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:flag,@"flag",type,@"type",typeid,@"channel", nil];
//    
//    id client = [self postRequestWithBaseUrl:BASE_URL andPath:@"/api/passport.php" andParameters:para  forSueccessful:^(id responseObject) {
//        //
//        NSDictionary *data = [responseObject objectForKey:@"data"];
//        NSError *err = nil;
//        if (data) {
//            NSMutableArray *BusinessContent = [data objectForKey:@"content"];
//            if (BusinessContent) {
//                sucess(BusinessContent);
//            }else{
//                err = [self errorWithMsg:@"BusinessContent is nil"];
//                fail(err);
//            }
//        }else{
//            err = [self errorWithMsg:@"data is nil"];
//            fail(err);
//        }
//    } forFail:^(NSError *error) {
//        //
//        fail(error);
//    }];
//    
//    return client;
//}
//
//-(instancetype)unionLoginWithUserID:(NSString *)userid
//                          unionType:(NSString *)unionType
//                      unionUsername:(NSString *)unionUsername
//                           unionPic:(NSString *)unionPic
//                            unionId:(NSString *)unionId
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:userid,@"userId",unionType,@"unionType",unionUsername,@"unionUsername",unionPic,@"unionPic",unionId,@"unionId", nil];
//    
//    id client = [self postRequestWithBaseUrl:BASE_URL andPath:@"/api/login.php" andParameters:para  forSueccessful:^(id responseObject) {
//        //
//        NSDictionary *data = [responseObject objectForKey:@"data"];
//        NSError *err = nil;
//        if (data) {
//            NSMutableArray *BusinessContent = [data objectForKey:@"content"];
//            if (BusinessContent) {
//                sucess(BusinessContent);
//            }else{
//                err = [self errorWithMsg:@"BusinessContent is nil"];
//                fail(err);
//            }
//        }else{
//            err = [self errorWithMsg:@"data is nil"];
//            fail(err);
//        }
//        //        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        //
//        fail(error);
//    }];
//    
//    return client;
//}
//
//
//-(instancetype)getVersionwithAct:(NSString *)act
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail;
//{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:act,@"act", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/api/get_version.php" andParameters:para forSueccessful:^(id responseObject) {
//        NSDictionary *dataDic=[[responseObject objectForKey:@"data"] objectForKey:@"content"];
//        sucess(dataDic);
//        
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    
//    return client;
//}
//
//
//-(instancetype)getTokenWithUserId:(NSString *)userid
//                              key:(NSString *)key
//                           sucess:(resultBlock)sucess
//                             fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:userid,@"user_id",key,@"key", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/api/get_token.php" andParameters:para forSueccessful:^(id responseObject) {
//        NSDictionary *dataDic=[[responseObject objectForKey:@"data"] objectForKey:@"content"];
//        
//        sucess(dataDic);
//        
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    
//    return client;
//}
//
//-(id)AddPushBindUserLogWithChannelId:(NSString*)channelId andUserDeviceId:(NSString*)userDeviceId forSuccess:(successfulBlock)success forFailed:(failWithErrorBlock)fail
//{
//    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:self.token, @"token",channelId, @"channelid", userDeviceId, @"userid", @"4", @"deviceType", @"1", @"appClientType", nil];
//    id client = [self postRequestWithBaseUrl:BASE_URL andPath:@"/api/push_userid.php" andParameters:para forSueccessful:^(id responseObject) {
//        
//        success();
//        
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    
//    return client;
//    
//}
//
//-(instancetype)sendVerificationCodeWithMobile:(NSString *)mobile
//                                         sucess:(resultBlock)sucess
//                                         fail:(failWithErrorBlock)fail
//{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",self.token,@"token", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/api/sms/sms.php" andParameters:para forSueccessful:^(id responseObject) {
//        NSDictionary *data=[responseObject objectForKey:@"data"];
//        sucess(data);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    
//    return client;
//}
//
//-(instancetype)getUserInfoWithPhone:(NSString *)phone
//                                uid:(NSString *)uid
//                              token:(NSString *)token
//                             search:(NSString *)search
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail
//{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone", search,@"search",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/user/info" andParameters:para forSueccessful:^(id responseObject) {
////        NSDictionary *data=[responseObject objectForKey:@"data"];
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)addFriendsWithPhone:(NSString *)phone
//                               uid:(NSString *)uid
//                             token:(NSString *)token
//                            friend:(NSString *)friend_id
//                            sucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail
//{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone", friend_id,@"friend_id",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/friend/request" andParameters:para forSueccessful:^(id responseObject) {
//        //        NSDictionary *data=[responseObject objectForKey:@"data"];
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//-(instancetype)conformFriendsWithPhone:(NSString *)phone
//                                   uid:(NSString *)uid
//                                 token:(NSString *)token
//                                friend:(NSString *)friend_id
//                                  type:(NSString *)type
//                                sucess:(resultBlock)sucess
//                                  fail:(failWithErrorBlock)fail;
//{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone", friend_id,@"friend_id",type,@"type",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/friend/response" andParameters:para forSueccessful:^(id responseObject) {
//        //        NSDictionary *data=[responseObject objectForKey:@"data"];
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getMyBusinessWithPhone:(NSString *)phone
//                                  uid:(NSString *)uid
//                                token:(NSString *)token
//                                limit:(NSString *)limit
//                                 type:(NSString *)type
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail
//{
//     NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",limit,@"limit",type,@"type", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/business/list" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getMyClassOrPublicWithPhone:(NSString *)phone
//                                       uid:(NSString *)uid
//                                     token:(NSString *)token
//                                     limit:(NSString *)limit
//                                      type:(NSString *)type
//                                    sucess:(resultBlock)sucess
//                                      fail:(failWithErrorBlock)fail
//{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",limit,@"limit",type,@"type", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/order/list" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//    
//    
//}
//
//-(instancetype)getbannnerWithPhone:(NSString *)phone
//                               uid:(NSString *)uid
//                             token:(NSString *)token
//                            banner:(NSString *)banner
//                              name:(NSString *)name
//                            sucess:(resultBlock)sucess
//                              fail:(failWithErrorBlock)fail{
//    
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",banner,@"id", name,@"name",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/pic/list" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//    
//}
//-(instancetype)getbannnerSingleWithPhone:(NSString *)phone
//                                     uid:(NSString *)uid
//                                   token:(NSString *)token
//                                  banner:(NSString *)banner
//                                    name:(NSString *)name
//                                  sucess:(resultBlock)sucess
//                                    fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",banner,@"id", name,@"name",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/pic/detail" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//    
//}
//
//-(instancetype)getMyCollectWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                               limit:(NSString *)limit
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",limit,@"limit", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/business/collect" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)postMyAdressListWithPhone:(NSString *)phone
//                                     uid:(NSString *)uid
//                                   token:(NSString *)token
//                                contacts:(NSString *)contacts
//                                  sucess:(resultBlock)sucess
//                                    fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",contacts,@"contacts", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/user/addressbook" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)uploadMyAdressListWithPhone:(NSString *)phone
//                                       uid:(NSString *)uid
//                                     token:(NSString *)token
//                                    sucess:(resultBlock)sucess
//                                      fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/user/downaddress" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//    
//}
//
//-(instancetype)editUserInfoWithPhone:(NSString *)phone
//                                uid:(NSString *)uid
//                              token:(NSString *)token
//                            content:(NSString *)content
//                               type:(NSString *)type
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",content,@"content",type,@"type", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/user/edit" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)reqestSignAlipaysign_data:(NSString *)sign_data
//                         sucess:(resultBlock)sucess
//                           fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:sign_data,@"sign_data", nil];
//    id client=[self postRequestWithBaseUrl:@"http://www.wqh365.com/" andPath:@"pay/alipay/sign" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    
//    return client;
//}
//
//-(instancetype)editUserClubWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                                name:(NSString *)name
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",name,@"name", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/user/club" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//        
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)refunedClassWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                            order_id:(NSString *)order_id
//                                type:(NSString *)type
//                                sign:(NSString *)sign
//                                name:(NSString *)name
//                             account:(NSString *)account
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",order_id,@"order_id",type,@"type", sign,@"sign",name,@"name",account,@"account",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/lesson/refund" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//        
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//    
//}
//
//-(instancetype)supplyDemandWithPhone:(NSString *)phone uid:(NSString *)uid token:(NSString *)token title:(NSString *)title content:(NSString *)content type:(NSString *)type sucess:(resultBlock)sucess fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",content,@"content",title,@"title",type,@"type", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/business/post" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//        
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)delelteSupplyDemandWithPhone:(NSString *)phone uid:(NSString *)uid token:(NSString *)token businessId:(NSString *)businessId sucess:(resultBlock)sucess fail:(failWithErrorBlock)fail{
//    
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",businessId,@"id", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/business/delete" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)collectSupplyDemandWithPhone:(NSString *)phone uid:(NSString *)uid token:(NSString *)token businessId:(NSString *)businessId type:(NSString *)type sucess:(resultBlock)sucess fail:(failWithErrorBlock)fail{
//    
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",businessId,@"type_id",type,@"type", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/user/collect" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)editSupplyDemandWithPhone:(NSString *)phone
//                                     uid:(NSString *)uid
//                                   token:(NSString *)token
//                                   title:(NSString *)title
//                                 content:(NSString *)content
//                                    type:(NSString *)type
//                              businessId:(NSString *)businessId
//                                  sucess:(resultBlock)sucess
//                                    fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",content,@"content",title,@"title",type,@"type",businessId,@"id", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/business/edit" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)uploadUserHeadIconWithPhone:(NSString *)phone
//                                       uid:(NSString *)uid
//                                     token:(NSString *)token
//                           encodedImageStr:(NSString *)encodedImageStr
//                                      type:(NSString *)type
//                                    sucess:(resultBlock)sucess
//                                      fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",encodedImageStr,@"pic",type,@"type",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/user/upload" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//    
//}
//
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
//                                    fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",name,@"name",pic,@"pic",address,@"address",description,@"description",company_phone,@"company_phone",industry,@"industry",@"2",@"auth_status",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/company/auth" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getWangCCTVWithPhone:(NSString *)phone
//                                uid:(NSString *)uid
//                              token:(NSString *)token
//                              limit:(NSString *)limit
//                             sucess:(resultBlock)sucess
//                               fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",limit,@"limit", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/link/list" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getDonationListWithPhone:(NSString *)phone
//                                    uid:(NSString *)uid
//                                  token:(NSString *)token
//                                  limit:(NSString *)limit
//                                 sucess:(resultBlock)sucess
//                                   fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",limit,@"limit", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/donation/list" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getArticleListWithPhone:(NSString *)phone
//                                   uid:(NSString *)uid
//                                 token:(NSString *)token
//                                 limit:(NSString *)limit
//                           category_id:(NSString *)category_id
//                                sucess:(resultBlock)sucess
//                                  fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",limit,@"limit",category_id,@"category_id", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/article/list" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getCompanyListWithPhone:(NSString *)phone
//                                   uid:(NSString *)uid
//                                 token:(NSString *)token
//                                 limit:(NSString *)limit
//                                sucess:(resultBlock)sucess
//                                  fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",limit,@"limit", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/company/list" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)donationsWithPhone:(NSString *)phone
//                              uid:(NSString *)uid
//                            token:(NSString *)token
//                       donationId:(NSString *)donationId
//                            price:(NSString *)price
//                           sucess:(resultBlock)sucess
//                             fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",donationId,@"id", price,@"price",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/donation/do" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)registrationCCTVWithPhone:(NSString *)phone
//                                     uid:(NSString *)uid
//                                   token:(NSString *)token
//                                    name:(NSString *)name
//                                 content:(NSString *)content
//                        contactTelephone:(NSString *)contactTelephone
//                                  sucess:(resultBlock)sucess
//                                    fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",name,@"name", content,@"content",contactTelephone,@"contactTelephone",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/user/cctv" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getLessonListWithPhone:(NSString *)phone
//                                  uid:(NSString *)uid
//                                token:(NSString *)token
//                                limit:(NSString *)limit
//                          category_id:(NSString *)category_id
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",limit,@"limit",category_id,@"category_id", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/lesson/list" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getUsersInfoListByPhonesWithPhone:(NSString *)phone
//                                             uid:(NSString *)uid
//                                           token:(NSString *)token
//                                      phoneArray:(NSString *)phoneArray
//                                          sucess:(resultBlock)sucess
//                                            fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",phoneArray,@"phoneArray", nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/user/infolist" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getPayWithPhone:(NSString *)phone
//                           uid:(NSString *)uid
//                         token:(NSString *)token
//                      lessonId:(NSString *)lessonId
//                        amount:(NSString *)amount
//                          type:(NSString *)type
//                      order_id:(NSString *)order_id
//                        sucess:(resultBlock)sucess
//                          fail:(failWithErrorBlock)fail{
//   NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",lessonId,@"id",amount,@"amount",type,@"type",order_id,@"order_id",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/lesson/buy" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//-(instancetype)getPayPublicWithPhone:(NSString *)phone
//                                 uid:(NSString *)uid
//                               token:(NSString *)token
//                            publicId:(NSString *)publicId
//                               price:(NSString *)price
//                                type:(NSString *)type
//                            order_id:(NSString *)order_id
//                              sucess:(resultBlock)sucess
//                                fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone",publicId,@"id",price,@"price",type,@"type", order_id,@"order_id",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/donation/buy" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//
//-(instancetype)deleteFriendsWithPhone:(NSString *)phone
//                                  uid:(NSString *)uid
//                                token:(NSString *)token
//                               friend:(NSString *)friend_id
//                               sucess:(resultBlock)sucess
//                                 fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",token,@"token",phone,@"phone", friend_id,@"friend_id",@"delete",@"type",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/friend/request" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//
//
//-(instancetype)findGroupWithGroupId:(NSString *)groupId
//                           sucess:(resultBlock)sucess
//                             fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:[Tools getValueFromKey:@"uid"],@"uid",[Tools getValueFromKey:@"token"],@"token",[Tools getValueFromKey:@"phone"],@"phone",groupId,@"search",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/chat/findgroup" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
//-(instancetype)creategroupWithHuanXinGroupId:(NSString *)groupId
//                                andGroupName:(NSString *)name
//                                      sucess:(resultBlock)sucess
//                                        fail:(failWithErrorBlock)fail{
//    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:[Tools getValueFromKey:@"uid"],@"uid",[Tools getValueFromKey:@"token"],@"token",[Tools getValueFromKey:@"phone"],@"phone",groupId,@"group_id",name,@"name",nil];
//    id client=[self postRequestWithBaseUrl:BASE_URL andPath:@"/v1/chat/creategroup" andParameters:para forSueccessful:^(id responseObject) {
//        sucess(responseObject);
//    } forFail:^(NSError *error) {
//        fail(error);
//    }];
//    return client;
//}
@end

