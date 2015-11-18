//
//  UICollectionView3DLayout.h
//  PagePaper
//
//  Created by 朱建伟 on 15/10/15.
//  Copyright © 2015年 zjw. All rights reserved.
//  暖男哥们建伟给写的collection布局

#import <UIKit/UIKit.h>



typedef enum
{
    UICollectionLayoutScrollDirectionVertical,
    UICollectionLayoutScrollDirectionHorizontal
} UICollectionLayouScrollDirection;


@interface UICollectionView3DLayout : UICollectionViewLayout
/**
 *  边框
 */
@property(nonatomic,assign)UIEdgeInsets sectionInset;


/**
 *  itemSize  每个Item的尺寸 默认剧中显示
 */
@property(nonatomic,assign)CGSize itemSize;


@property(nonatomic,assign)UICollectionLayouScrollDirection LayoutDirection;

/**
 *  垂直间距
 */
@property(nonatomic,assign)CGFloat rowSpace;

/**
 *  水平间距
 */
@property(nonatomic,assign)CGFloat columSpace;

/**
 *  scale
 */
@property(nonatomic,assign)CGFloat itemScale;

//-(void)ExcuteScrolling;
-(void)EndAnchorMove;
-(void)ExcuteEndAnimate;
@end
