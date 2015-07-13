
//  Copyright (c) 2014年 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMHttpTool : NSObject

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)cancleAll;
@end
