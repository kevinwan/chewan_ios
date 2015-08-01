//
//  CPPhotoalbumManagement.h
//  CarPlay
//
//  Created by 公平价 on 15/7/29.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"

@interface CPPhotoalbumManagement : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (nonatomic, strong) NSArray *albumPhotos;
@end
