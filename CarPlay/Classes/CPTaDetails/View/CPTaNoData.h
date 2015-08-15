//
//  CPTaNoData.h
//  CarPlay
//
//  Created by 公平价 on 15/8/11.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTaNoData : UIView

@property (nonatomic,copy) NSString *pictureName;

@property (nonatomic,copy) NSString *titleName;

+ (CPTaNoData *)footerView;

@end
