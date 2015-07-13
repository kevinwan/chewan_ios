//
//  _wanCheNetWork.h
//  CarPlay
//
//  Created by 牛鹏赛 on 15-7-8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^failWithErrorBlock)(NSError *error);
typedef void(^successfulBlock)();
typedef void(^resultBlock)(id result);


@interface CPNetWork : NSObject

//登录成功后保存token
@property(nonatomic, strong, readonly)NSString *token;
+(instancetype)sharedInstance;

-(NSURL*)makeURLWithBaseUrl:(NSString*)url Suffix:(NSString*)path;
-(NSURLRequest*)makeRequstWithBaseUrl:(NSString*)url andPath:(NSString*)path andObjectsAndKeys:(id)firstObject, ...;
-(id)postRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters forSueccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error)) fail;

-(id)postRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters andHeadersParams:(NSDictionary *)headerDic forSueccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error)) fail;

-(id)postRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters andParameterEncoding:(AFHTTPClientParameterEncoding)parameterEncoding forSueccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error)) fail;

-(id)getRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters andHeadersParams:(NSDictionary *)headerDic forSuccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error))fail;

-(id)getRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters forSuccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error))fail;

-(id)getRequestWithBaseUrl2:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters forSuccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error))fail;//无state返回时

-(id)multipartPostWithBaseUrl:(NSString *)url andPath:(NSString *)path andParameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block uploadProgressBlock:(void (^)(NSUInteger, long long, long long))progress forSuccessful:(resultBlock)successful forFail:(failWithErrorBlock)fail;

-(id)multipartPostWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress completionSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))fail;
-(id)multipartWithMethod:(NSString*)method andBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress completionSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))fail;

-(NSURLRequest*)makeGetRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters;
-(NSError*)errorWithMsg:(NSString*)msg;

-(id)getRequestForSinaShortUrlWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters forSuccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error))fail;
@end
