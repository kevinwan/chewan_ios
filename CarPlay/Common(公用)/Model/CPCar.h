//
//  CPCar.h
//  CarPlay
//
//  Created by 公平价 on 15/10/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPCar : NSObject
//"brand": "大众",
@property (nonatomic, copy) NSString *brand;
//"slug": "dazhong-cc"
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *model;
@end

