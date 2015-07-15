//
//  CPHttpTool.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYHttpTool.h"
#import "AFJSONRequestOperation.h"
@implementation ZYHttpTool

+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failed:(void (^)(NSError *))failed
{
    //为所有接口加上token
    
    NSURLRequest *request = [self makeGetRequestWithBaseUrl:url andParameters:params];

    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",  nil]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSLog(@"json : %@", JSON);
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            if (success) {
                success(JSON);
            }
        }else{
            DLog(@"返回数据不是JSON数据");
            NSError *err = [[NSError alloc]initWithDomain:@"data 不是json数据" code:-1 userInfo:nil];
            if (failed) {
                failed(err);
            }
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        if (failed) {
            failed(error);
        }
    }];
    [operation start];
}

+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failed:(void (^)(NSError *))failed
{
    
}


/**
 *  get请求路径参数拼接
 *
 *  @param url        基本url
 *  @param parameters 请求参数
 *
 *  @return NSURLRequest对象
 */
+(NSURLRequest*)makeGetRequestWithBaseUrl:(NSString*)url andParameters:(NSDictionary*)parameters
{
    NSURLRequest *req;
    NSMutableString *string = [NSMutableString stringWithString:url];
    
    if (parameters) {
        NSEnumerator *en = [parameters keyEnumerator];
        NSArray *keys = [en allObjects];
        int i;
        NSUInteger count = keys.count;
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

@end
