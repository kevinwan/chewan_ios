//
//  CPEditImageView.h
//  CarPlay
//
//  Created by chewan on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPEditImageView : UIImageView
@property (nonatomic, assign) BOOL select;
@property (nonatomic, assign) BOOL showSelectImage;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *coverId;
@end
