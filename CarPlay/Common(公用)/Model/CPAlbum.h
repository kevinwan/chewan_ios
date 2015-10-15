//
//  CPAlbum.h
//  CarPlay
//
//  Created by 公平价 on 15/10/14.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPAlbum : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) long long uploadTime;
@end
