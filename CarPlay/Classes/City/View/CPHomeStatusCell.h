//
//  CPHomeStatusCell.h
//  CarPlay
//
//  Created by 公平价 on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPHomeStatus;

typedef void (^PictureDidSelected)(CPHomeStatus *status,NSIndexPath *path, NSArray *srcView);
typedef void (^tapIcons)(CPHomeStatus *status);

@interface CPHomeStatusCell : UITableViewCell
// 我要去玩
@property (weak, nonatomic) IBOutlet UIButton *myPlay;
// 头像collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *iconView;
@property (nonatomic,strong) CPHomeStatus *status;



+ (NSString *)identifier;

// 返回每一行有多高
- (CGFloat)cellHeightWithStatus:(CPHomeStatus *)status;

// 回调函数
@property (nonatomic,copy) PictureDidSelected pictureDidSelected;
@property (nonatomic, copy) tapIcons tapIcons;
@end
