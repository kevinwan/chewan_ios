//
//  CPSelectView.h
//  CarPlay
//
//  Created by chewan on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPSelectView,CPSelectViewModel;
@protocol CPSelectViewDelegate <NSObject>

- (void)selectView:(CPSelectView *)selectView finishBtnClick:(CPSelectViewModel *)result;

- (void)selectViewCancleBtnClick:(CPSelectView *)selectView;

@end

@interface CPSelectView : UIView

@property (nonatomic, assign) id<CPSelectViewDelegate> delegate;

+ (instancetype)selectView;

- (void)showWithView:(UIView *)view;

- (void)dismissWithCompletion:(void (^)())completion;

@end


@interface CPSelectViewModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, assign) int authenticate;
@property (nonatomic, copy) NSString *carLevel;

@end
