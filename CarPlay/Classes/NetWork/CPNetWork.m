    //
//  _wanCheNetWork.m
//  CarPlay
//
//  Created by 牛鹏赛 on 15-7-8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNetWork.h"

static CPNetWork * _wanCheNetWork = nil;

@implementation CPNetWork

+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _wanCheNetWork = [[self alloc] init];
    });
    
    return _wanCheNetWork;
}

#pragma mark - 登录标记
-(NSString*)token
{
    NSString *token = nil;
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    token = [df objectForKey:@"token"];
    if (token == nil||[token length] == 0) {
        
        token = @"";
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"未登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
    }
    
    return token;
}


/**
 *  传入字符串生成URL
 *
 *  @param url  基本URL
 *  @param path url路径地址
 *
 *  @return NSURL 请求地址
 */
-(NSURL*)makeURLWithBaseUrl:(NSString*)url Suffix:(NSString*)path
{
    NSURL *u = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", url, path]];
    return u;
}

/**
 *  get生成请求
 *
 *  @param url         基本URL
 *  @param path        路径地址
 *  @param firstObject 拼接的参数,无法列出参数的多少，以省略号结束
 *
 *  @return NSURLRequest
 */
-(NSURLRequest*)makeRequstWithBaseUrl:(NSString*)url andPath:(NSString*)path andObjectsAndKeys:(id)firstObject, ...
{
    NSMutableString *string = [[NSMutableString alloc] initWithFormat:@"%@%@", url, path];
    
    va_list paraList;
    id arg;
    BOOL isObject = YES;
    
    if (firstObject) {
        [string appendString:@"?"];
        NSString *tem = firstObject;
        /**
         *  读取可变参数，使用指针遍历堆栈中参数列表
         */
        va_start(paraList, firstObject);
        
        while ( (arg = va_arg(paraList, id)) ) {
            
            if (isObject) {
                [string appendFormat:@"%@=%@", arg, tem];
                isObject = NO;
            }else{
                [string appendString:@"&"];
                tem = arg;
                isObject = YES;
            }
        }
        
        va_end(paraList);
    }else{
        return nil;
    }
    
    NSString *s =  [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:s];
    NSURLRequest *req = [NSURLRequest requestWithURL:URL];
    DLog(@"请求地址:%@", string);
    return req;
}
/**
 *  传入请求参数，返回请求数据
 *
 *  @param url        基本url
 *  @param path       请求路径
 *  @param parameters 请求参数
 *  @param block      block data数据参数
 *  @param progress   进度
 *  @param successful 成功返回
 *  @param fail       失败返回
 *
 *  @return 返回请求结果对象。
 */
-(id)multipartPostWithBaseUrl:(NSString *)url andPath:(NSString *)path andParameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block uploadProgressBlock:(void (^)(NSUInteger, long long, long long))progress forSuccessful:(resultBlock)successful forFail:(failWithErrorBlock)fail{
    DLog(@"--------文件上传的URL:%@%@:参数:%@-----", url, path, parameters);
    id client = [self multipartPostWithBaseUrl:url andPath:path andParameters:parameters constructingBodyWithBlock:block uploadProgressBlock:progress completionSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (json) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *state=[numberFormatter stringFromNumber:[json objectForKey:@"state"]];
                if ([state isEqualToString:@"1"]) {
                    DLog(@"POST返回的数据:%@------------------------------------", json);
                    successful(json);
                }else{
                    DLog(@"接口返回失败:%@", json);
                    NSString *msg = [json objectForKey:@"msg"];
                    NSError *err = [self errorWithMsg:msg];
                    fail(err);
                }
            }else{
                DLog(@"返回数据不是JSON数据:%@", [json class]);
                NSError *err = [self errorWithMsg:@"data is not json"];
                fail(err);
            }
        }else{
            DLog(@"解析数据失败:%@", json);
            fail(error);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // [SVProgressHUD dismiss];

        fail(error);
    }];
    
    return client;
}


-(id)multipartPostWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress completionSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))fail
{
    id ret = [self multipartWithMethod:@"POST" andBaseUrl:url andPath:path andParameters:parameters constructingBodyWithBlock:block uploadProgressBlock:progress completionSuccess:success failure:fail];
    return ret;
}

-(id)postRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters forSueccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error)) fail
{
    id client = [self postRequestWithBaseUrl:url andPath:path andParameters:parameters andParameterEncoding:AFJSONParameterEncoding forSueccessful:successful forFail:fail];
    return client;
}
/**
 *  post请求自定义编码类型。
 *
 *  @param url               基本url
 *  @param path              路径
 *  @param parameters        上传参数
 *  @param parameterEncoding 编码类型
 *  @param successful        成功后block
 *
 *  @return 请求结果对象json串
 */

-(id)postRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters andParameterEncoding:(AFHTTPClientParameterEncoding)parameterEncoding forSueccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error)) fail
{
    //为所有接口加上token
    NSMutableDictionary *mutParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    if (![mutParameters.allKeys containsObject:@"token"] && ![mutParameters.allKeys containsObject:@"Token"]) {
//        [mutParameters setValue:self.token forKey:@"token"];
//    };
    
    DLog(@"POST请求地址:%@%@.请求的参数:%@------------------------------------", url, path, mutParameters);
    
    NSURL *u = [NSURL URLWithString:url];
    
    AFHTTPClient *clinet = [[AFHTTPClient alloc] initWithBaseURL:u];
    clinet.parameterEncoding = parameterEncoding;
    [clinet postPath:path parameters:mutParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSString *resStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data_utf8 = [resStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data_utf8 options:kNilOptions error:&error];
       
        if (json) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *state=[numberFormatter stringFromNumber:[json objectForKey:@"result"]];
                if ([state isEqualToString:@"0"]) {
                    DLog(@"POST返回的数据:%@------------------------------------", json);
                    successful(json);
                }else{
                    DLog(@"接口返回失败:%@", json);
                    NSString *msg = [json objectForKey:@"errmsg"];
                    DLog(@"message:%@",msg);
                    NSError *err = [self errorWithMsg:msg];
                   [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    fail(err);
                }
            }else{
                DLog(@"返回数据不是JSON数据:%@", [json class]);
                NSError *err = [self errorWithMsg:@"data is not json"];
                fail(err);
            }
        }else
        {
            DLog(@"解析数据失败:%@", json);
            fail(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        DLog(@"网络访问失败%@", error);
        fail(error);
    }];
    
    return clinet;
    
}

-(id)postRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters andHeadersParams:(NSDictionary *)headerDic forSueccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error)) fail
{
    //为所有接口加上token
    NSMutableDictionary *mutParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (![mutParameters.allKeys containsObject:@"token"] && ![mutParameters.allKeys containsObject:@"Token"]) {
        [mutParameters setValue:self.token forKey:@"token"];
    };
    DLog(@"POST请求地址:%@%@.请求的参数:%@------------------------------------", url, path, mutParameters);
    
    NSURL *u = [NSURL URLWithString:url];
    
    AFHTTPClient *clinet = [[AFHTTPClient alloc] initWithBaseURL:u];
    clinet.parameterEncoding = AFFormURLParameterEncoding;
    
    NSArray *allKeys = [headerDic allKeys];
    //    NSArray *allValue = [headerDic allValues];
    for(int i = 0;i < [headerDic count];i++){
        NSString *key = [allKeys objectAtIndex:i];
        //NSString *obj =[allValue objectAtIndex:i];
        NSString *obj = [headerDic objectForKey:key];
        
        [clinet setDefaultHeader:@"Authorization" value:obj];
        
    }
    
    [clinet postPath:path parameters:mutParameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSString *resStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data_utf8 = [resStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data_utf8 options:kNilOptions error:&error];
        if (json) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *state=[numberFormatter stringFromNumber:[json objectForKey:@"result"]];
                if ([state isEqualToString:@"0"]) {
                    DLog(@"POST返回的数据:%@------------------------------------", json);
                    successful(json);
                }else{
                    DLog(@"接口返回失败:%@", json);
                    NSString *msg = [json objectForKey:@"errmsg"];
                    DLog(@"message:%@",msg);
                    NSError *err = [self errorWithMsg:msg];
                    fail(err);
                }
            }else{
                DLog(@"返回数据不是JSON数据:%@", [json class]);
                NSError *err = [self errorWithMsg:@"data is not json"];
                fail(err);
            }
        }else
        {
            DLog(@"解析数据失败:%@", json);
            fail(error);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        DLog(@"网络访问失败%@", error);

        fail(error);
    }];
    
    return clinet;
}


-(id)getRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters andHeadersParams:(NSDictionary *)headerDic forSuccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error))fail{
    
    //为所有接口加上token
    NSMutableDictionary *mutParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (![mutParameters.allKeys containsObject:@"token"] && ![mutParameters.allKeys containsObject:@"Token"]) {
        [mutParameters setValue:self.token forKey:@"token"];
    };
    
    NSLog(@"GET请求地址:%@%@.请求的参数:%@", url, path, parameters);
    
    NSURLRequest *request = [self makeGetRequestWithBaseUrl:url andPath:path andParameters:mutParameters];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    //    [mutableRequest addValue:@"Hless" forHTTPHeaderField:@"X-user-nick"];
    
    NSArray *allKeys = [headerDic allKeys];
    //    NSArray *allValue = [headerDic allValues];
    for(int i = 0;i < [headerDic count];i++){
        NSString *key = [allKeys objectAtIndex:i];
        //NSString *obj =[allValue objectAtIndex:i];
        NSString *obj = [headerDic objectForKey:key];
        
        [mutableRequest addValue:obj forHTTPHeaderField:key];
        
    }
    
    request = [mutableRequest copy];
    
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        DLog(@"json : %@", JSON);
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *state=[numberFormatter stringFromNumber:[JSON objectForKey:@"state"]];
            if ([state isEqualToString:@"1"]) {
                successful(JSON);
            }else{
                NSLog(@"接口返回失败");
                NSString *msg = [JSON objectForKey:@"msg"];
                NSError *err = [self errorWithMsg:msg];
                fail(err);
            }
        }else{
            DLog(@"返回数据不是JSON数据");
            NSError *err = [self errorWithMsg:@"data is not json"];
            fail(err);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        
        fail(error);
        
    }];
    [operation start];
    
    return operation;
    
}

-(id)getRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters forSuccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error))fail
{
    //为所有接口加上token
    NSMutableDictionary *mutParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    if (![mutParameters.allKeys containsObject:@"token"] && ![mutParameters.allKeys containsObject:@"Token"]) {
//        [mutParameters setValue:self.token forKey:@"token"];
//    };
    
    NSLog(@"GET请求地址:%@%@.请求的参数:%@", url, path, parameters);
    
    NSURLRequest *request = [self makeGetRequestWithBaseUrl:url andPath:path andParameters:mutParameters];
//    NSMutableURLRequest *mutableRequest = [request mutableCopy];
//    [mutableRequest addValue:@"Hless" forHTTPHeaderField:@"X-user-nick"];
//    
//    request = [mutableRequest copy];
    
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        DLog(@"json : %@", JSON);
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *state=[numberFormatter stringFromNumber:[JSON objectForKey:@"state"]];
            if ([state isEqualToString:@"1"]) {
                successful(JSON);
            }else{
//                DLog(@"接口返回失败");
//                NSString *msg = [JSON objectForKey:@"msg"];
//                NSError *err = [self errorWithMsg:msg];
//                fail(err);
            }
        }else{
            DLog(@"返回数据不是JSON数据");
            NSError *err = [self errorWithMsg:@"data is not json"];
            fail(err);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        fail(error);
    }];
    [operation start];
    
    return operation;
}

-(id)getRequestWithBaseUrl2:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters forSuccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error))fail
{
    //为所有接口加上token
    NSMutableDictionary *mutParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    //    if (![mutParameters.allKeys containsObject:@"token"] && ![mutParameters.allKeys containsObject:@"Token"]) {
    //        [mutParameters setValue:self.token forKey:@"token"];
    //    };
    
    NSLog(@"GET请求地址:%@%@.请求的参数:%@", url, path, parameters);
    
    NSURLRequest *request = [self makeGetRequestWithBaseUrl:url andPath:path andParameters:mutParameters];
    //    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    //    [mutableRequest addValue:@"Hless" forHTTPHeaderField:@"X-user-nick"];
    //
    //    request = [mutableRequest copy];
    
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        DLog(@"json : %@", JSON);
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *state=[numberFormatter stringFromNumber:[JSON objectForKey:@"state"]];
            successful(JSON);
            }else
            {
            DLog(@"返回数据不是JSON数据");
            NSError *err = [self errorWithMsg:@"data is not json"];
            fail(err);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        fail(error);
    }];
    [operation start];
    
    return operation;
}

/**
 *  get请求路径参数拼接
 *
 *  @param url        基本url
 *  @param path       路径
 *  @param parameters 请求参数
 *
 *  @return NSURLRequest对象
 */
-(NSURLRequest*)makeGetRequestWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters
{
    NSURLRequest *req;
    NSMutableString *string = [NSMutableString stringWithString:url];
    if (path) {
        [string appendFormat:@"%@", path];
    }
    
    if (parameters) {
        NSEnumerator *en = [parameters keyEnumerator];
        NSArray *keys = [en allObjects];
        int i;
        int count = keys.count;
        NSString *k = nil;
        NSString *v = nil;
        for (i = 0; i < count; i++) {
            if (i == 0) {
                [string appendString:@"?"];
            }
            k = [keys objectAtIndex:i];
            v = [parameters objectForKey:k];
            [string appendString:[NSString stringWithFormat:@"%@=%@", k, v]];
            if (i < count - 1) {
                [string appendString:@"&"];
            }
        }
    }
    
    NSLog(@"get的请求地址：%@", string);
    req = [NSURLRequest requestWithURL:[NSURL URLWithString:string] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    return req;
}

/**
 *  请求失败时候提示的错误信息
 *
 *  @param msg 错误信息字符串
 *
 *  @return NSError错误信息
 */
-(NSError*)errorWithMsg:(NSString*)msg
{
    NSError *err = [[NSError alloc]initWithDomain:msg code:-1 userInfo:nil];
    return err;
}

-(id)getRequestForSinaShortUrlWithBaseUrl:(NSString*)url andPath:(NSString*)path andParameters:(NSDictionary*)parameters forSuccessful:(void(^)(id responseObject))successful forFail:(void(^)(NSError *error))fail
{
    NSLog(@"POST请求地址:%@%@.请求的参数:%@", url, path, parameters);
    
    NSURLRequest *request = [self makeGetRequestWithBaseUrl:url andPath:path andParameters:parameters];
    
    //    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        DLog(@"json : %@", JSON);
    
        NSLog(@"%@",[JSON class]);
        NSLog(@"%@",JSON);
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            successful(JSON);
//            if ([[[JSON objectForKey:@"urls"] objectAtIndex:3] isEqualToString:@"0"]) {
//                successful(JSON);
//            }else{
//                DLog(@"接口返回失败");
//                NSString *msg = [JSON objectForKey:@"msg"];
//                NSError *err = [self errorWithMsg:msg];
//                fail(err);
//            }
        }else{
            DLog(@"返回数据不是JSON数据");
            NSError *err = [self errorWithMsg:@"data is not json"];
            fail(err);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        //        fail(error);
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            successful([JSON objectForKey:@"offer"]);
        }
        
    }];
    [operation start];
    
    return operation;
}
@end
