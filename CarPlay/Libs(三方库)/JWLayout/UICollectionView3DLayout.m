//
//  UICollectionView3DLayout.m
//  PagePaper
//
//  Created by 朱建伟 on 15/10/15.
//  Copyright © 2015年 zjw. All rights reserved.
//
/**
 *  缩放缩小比例 (0 - 1)
 */
#define KItemScale 0.9

/**
 *  移动多少点就切换到下一页
 */
#define KMoveALitleDistance 30

#define KHasNavBar 64

#define KScreenW  [UIScreen mainScreen].bounds.size.width
#define KScreenH  [UIScreen mainScreen].bounds.size.height

typedef enum
{
    LayoutDirectionUp,
    LayoutDirectionDown,
    LayoutDirectionLeft,
    LayoutDirectionRight
} LayoutDirection;

#import "UICollectionView3DLayout.h"

@interface UICollectionView3DLayout()
/**
 *  属性数组
 */
@property(nonatomic,strong)NSMutableArray *attributes;

/**
 *   item个数
 */
@property(nonatomic,assign)NSInteger itemCount;

/**
 *  最大X contentSizeW
 */
@property(nonatomic,assign)CGFloat maxXOrY;


@property(nonatomic,assign)CGFloat itemY;
@property(nonatomic,assign)CGFloat UnitOffSetX;

@property(nonatomic,assign)CGFloat itemX;
@property(nonatomic,assign)CGFloat UnitOffSetY;


@property(nonatomic,assign)LayoutDirection direction;
@property(nonatomic,assign)CGPoint prePoint;

@property(nonatomic,assign)LayoutDirection preDirection;

@property(nonatomic,assign)BOOL  isScrolling;

@end

@implementation UICollectionView3DLayout


-(instancetype)init
{
   self= [super init];
    
    if (self) {
        _LayoutDirection=UICollectionLayoutScrollDirectionVertical;
        _sectionInset=UIEdgeInsetsMake(20, 30, 20, 30);
        _itemSize=CGSizeMake(KScreenW-self.sectionInset.left-self.sectionInset.right, KScreenH-self.sectionInset.top-self.sectionInset.bottom-KHasNavBar);
        _columSpace=5;
        _rowSpace=5;
        _itemScale=0.9;
    }
    
  return self;
}


-(void)setItemSize:(CGSize)itemSize
{
    _itemSize=itemSize;
    
    CGFloat top=20;
   
    if (self.LayoutDirection==UICollectionLayoutScrollDirectionHorizontal) {
        top=(KScreenH-KHasNavBar-itemSize.height)*0.5;
    }else
    {
        if (KScreenH<=480.0) {
            top=0;
        }
    }
    CGFloat Bottom=(KScreenH-KHasNavBar-itemSize.height)-top;
    CGFloat leftOrRight=(KScreenW-itemSize.width)*0.5;
    _sectionInset=UIEdgeInsetsMake(top,leftOrRight , Bottom, leftOrRight);
}

-(void)setLayoutDirection:(UICollectionLayouScrollDirection)LayoutDirection
{
    _LayoutDirection=LayoutDirection;
    
     CGFloat top=20;
    if (self.LayoutDirection==UICollectionLayoutScrollDirectionHorizontal) {
        top=(KScreenH-KHasNavBar-self.itemSize.height)*0.5;
    }else
    {
        if (KScreenH<=480.0) {
            top=0;
        }
    }
    CGFloat Bottom=(KScreenH-KHasNavBar-self.itemSize.height)-top;
    CGFloat leftOrRight=(KScreenW-self.itemSize.width)*0.5;
    _sectionInset=UIEdgeInsetsMake(top,leftOrRight , Bottom, leftOrRight);
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}



/**
 *  将要布局
 */
-(void)prepareLayout
{
    [super prepareLayout];
    
    self.collectionView.zoomScale=0.5;
    
    self.maxXOrY=0;
    
    NSInteger itemsAtZeroSection=[self.collectionView numberOfItemsInSection:0];
    
    self.itemCount=itemsAtZeroSection;
    
    [self.attributes removeAllObjects];
    
    for (NSInteger i=0; i<itemsAtZeroSection ; i++) {
        [self.attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    
}


-(CGSize)collectionViewContentSize
{
    if (self.LayoutDirection==UICollectionLayoutScrollDirectionHorizontal) {
        return CGSizeMake(self.maxXOrY+self.sectionInset.right, 0);
    }else
        
    {
        return CGSizeMake(0, self.maxXOrY+self.sectionInset.bottom);
    }
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
 
    if (self.LayoutDirection==UICollectionLayoutScrollDirectionHorizontal) {
        if (self.prePoint.x>self.collectionView.contentOffset.x) {
            self.direction=LayoutDirectionRight;
        }else
        {
            self.direction=LayoutDirectionLeft;
        }
    }else
    {
        self.preDirection=self.direction;
        if (self.prePoint.y>self.collectionView.contentOffset.y) {
            self.direction=LayoutDirectionDown;
        }else
        {
            self.direction=LayoutDirectionUp;
        }
    }
    
    
    self.prePoint=CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
    
    
    return self.attributes;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame=CGRectZero;
    
    CGFloat scale=0;
    
    if (self.LayoutDirection==UICollectionLayoutScrollDirectionHorizontal) {
        CGFloat x=self.sectionInset.left+self.UnitOffSetX*indexPath.item;
        frame= CGRectMake(x,self.itemY, self.itemSize.width, self.itemSize.height);
        scale=[self getScaleAtContentOffSetXOrY:self.collectionView.contentOffset.x andFrame:frame];
        self.maxXOrY=CGRectGetMaxX(frame);
    }else
    {
        CGFloat y= self.sectionInset.top+self.UnitOffSetY*indexPath.item+KHasNavBar;
        
        frame= CGRectMake(self.itemX,y, self.itemSize.width, self.itemSize.height);
        scale=[self getScaleAtContentOffSetXOrY:self.collectionView.contentOffset.y andFrame:frame];
        self.maxXOrY=CGRectGetMaxY(frame);
    }
    attr.frame=frame;
    
    attr.alpha= scale;
    
    attr.transform3D = CATransform3DMakeScale(scale, scale, scale);
    
    return attr;
}


-(CGFloat)getScaleAtContentOffSetXOrY:(CGFloat)offSetXOrY andFrame:(CGRect)frame
{
 
    if (self.LayoutDirection==UICollectionLayoutScrollDirectionHorizontal) {
        CGFloat midX=CGRectGetMidX(frame)-offSetXOrY;
        CGFloat screenMidX=KScreenW*0.5;
        
        CGFloat offsetValue= midX-screenMidX>0?midX-screenMidX:screenMidX-midX;
        if(offsetValue<self.UnitOffSetX){
            
            return  1-(1/self.UnitOffSetX)*offsetValue*(1-self.itemScale);
        }

    }else
    {
        CGFloat midY=CGRectGetMidY(frame)-offSetXOrY;
        CGFloat screenMidY=KScreenH*0.5+KHasNavBar*0.5;
        
        CGFloat offsetValue= midY-screenMidY>0?midY-screenMidY:screenMidY-midY;
        if(offsetValue<self.UnitOffSetY){
            
            return  1-(1/self.UnitOffSetY)*offsetValue*(1-self.itemScale);
        }

    }
    
    return  self.itemScale;
}

/**
 *  懒惰加载
 */
-(NSMutableArray *)attributes
{
    if (_attributes==nil) {
        _attributes=[NSMutableArray array];
    }
    return _attributes;
}

-(CGFloat)itemY
{
    if (_itemY==0) {
        _itemY=KScreenH-self.sectionInset.bottom-self.itemSize.height-KHasNavBar;
    }
    return _itemY;
}

-(CGFloat)itemX
{
    if (_itemX==0) {
        _itemX=KScreenW-self.sectionInset.right-self.itemSize.width;
    }
    return _itemX;
}
-(CGFloat)UnitOffSetX
{
    if (_UnitOffSetX==0) {
        _UnitOffSetX=(self.itemSize.width+self.columSpace*0.125);//*0.125);
    }
    return _UnitOffSetX;
}

-(CGFloat)UnitOffSetY
{
    if (_UnitOffSetY==0) {
        _UnitOffSetY=(self.itemSize.height+self.rowSpace*0.125);//*0.125);
    }
    return _UnitOffSetY;
}

-(void)EndAnchorMove
{
     self.isScrolling=NO;
  
 
    [self EndOrCancelMove:YES];
    
}

/**
 *  结束或者取消滚动
 */
-(void)EndOrCancelMove:(BOOL)isNeed
{
    CGFloat offsetXOrY=0;
    NSInteger quotient=0;
    CGFloat remainder=0;
    CGFloat ReduceOrAdd=0;
    CGPoint offset=CGPointZero;
    
    if(self.LayoutDirection==UICollectionLayoutScrollDirectionHorizontal){
        offsetXOrY = self.collectionView.contentOffset.x;
        quotient=offsetXOrY/self.UnitOffSetX;
        remainder=offsetXOrY-(quotient*self.UnitOffSetX);
        
        if (remainder==0.0) {
            return;
        }
        CGFloat LeftValue=KMoveALitleDistance;
        
        CGFloat leftEelse=0;
        CGFloat RightElse=0;
        
        if (remainder>LeftValue&&remainder<self.UnitOffSetX-LeftValue&&self.direction==LayoutDirectionLeft) {
            ReduceOrAdd=self.UnitOffSetX-remainder;
        }else
        {
            leftEelse=self.UnitOffSetX-remainder;
            
        }
        
        if(remainder<self.UnitOffSetX-LeftValue&&self.direction==LayoutDirectionRight)
        {
            ReduceOrAdd=-remainder;
        }else
        {
            RightElse=self.UnitOffSetX-remainder;
            
        }
        
        if(self.direction==LayoutDirectionLeft)
        {
            if(leftEelse!=0)
            {
                ReduceOrAdd=-remainder;
            }
        }else
        {
            if (RightElse!=0) {
                ReduceOrAdd=self.UnitOffSetX-remainder;
            }
        }
        
        
         offset=CGPointMake(self.collectionView.contentOffset.x+ReduceOrAdd, self.collectionView.contentOffset.y);
    }else
    {
        offsetXOrY = self.collectionView.contentOffset.y;
        quotient=offsetXOrY/self.UnitOffSetY;
        remainder=offsetXOrY-(quotient*self.UnitOffSetY);
        
        if (remainder==0.0) {
            return;
        }
        
        CGFloat RightValue=KMoveALitleDistance;
        
        CGFloat UpEelse=0;
        CGFloat DownElse=0;
        
        BOOL flag=YES;
        if (remainder>RightValue&&remainder<self.UnitOffSetY-RightValue&&self.direction==LayoutDirectionUp&&self.preDirection==LayoutDirectionUp) {
            flag=NO;
            ReduceOrAdd=self.UnitOffSetY-remainder;
        }else
        {
            UpEelse=self.UnitOffSetY-remainder;
            
        }
        
        if(remainder<self.UnitOffSetY-RightValue&&self.preDirection==LayoutDirectionDown&&flag
        )
        {
            ReduceOrAdd=-remainder;
        }else
        {
            DownElse=self.UnitOffSetY-remainder;
            
        }
        
        if(self.direction==LayoutDirectionUp)
        {
            if(UpEelse!=0)
            {
                ReduceOrAdd=-remainder;
            }
        }else
        {
            if (DownElse!=0) {
                ReduceOrAdd=self.UnitOffSetY-remainder;
            }
        }
        
        
        offset=CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+ReduceOrAdd);
    }
    
    
    [self.collectionView setContentOffset:offset animated:YES];
    
//    if (isNeed) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.28 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self ExcuteEndAnimate];
//            });
//    }
}

/**
 *  抖动
 */
-(void)ExcuteEndAnimate
{
    
    if (self.isScrolling) {
        return;
    }
    
    LayoutDirection  direction =self.direction ;
    
    CGFloat offsetDistance=10.0;
    
    CGFloat offsetValue=0;
   
    
    CGPoint point=self.collectionView.contentOffset;
    
    if (self.LayoutDirection==UICollectionLayoutScrollDirectionHorizontal) {
        if (direction==LayoutDirectionLeft) {
            offsetValue=-offsetDistance;
        }else if(direction==LayoutDirectionRight)
        {
            offsetValue=offsetDistance;
        }
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x+offsetValue, self.collectionView.contentOffset.y) animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView setContentOffset:point animated:YES];
        });

    }else
    {
        if (direction==LayoutDirectionUp) {
            offsetValue=-offsetDistance;
        }else if(direction==LayoutDirectionDown)
        {
            offsetValue=offsetDistance;
        }
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+offsetValue) animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView setContentOffset:point animated:YES];
        });

    }
}
-(void)ExcuteScrolling
{
    self.isScrolling=YES;
}
@end
