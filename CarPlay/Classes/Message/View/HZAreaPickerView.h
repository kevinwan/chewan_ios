//
//  HZAreaPickerView.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZLocation.h"
@class HZAreaPickerView;

@protocol HZAreaPickerDatasource <NSObject>

- (NSArray *)areaPickerData:(HZAreaPickerView *)picker;

@end

@protocol HZAreaPickerDelegate <NSObject>

@optional
- (void)pickerCancle;
- (void)pickerDoneClick:(HZAreaPickerView *)pickerView;

@end

@interface HZAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <HZAreaPickerDelegate> delegate;
@property (strong, nonatomic) UIPickerView *locatePicker;
@property (strong, nonatomic) HZLocation *locate;

- (id)initWithDelegate:(id <HZAreaPickerDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;
// 不带动画,直接移除
- (void)removeFromWindow;
@end
