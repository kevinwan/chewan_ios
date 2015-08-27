//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3
#define KToolBarHeight 40
#define KPickerHeght 216
@interface HZAreaPickerView ()
@property (nonatomic, strong) NSMutableArray *provinces;
@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation HZAreaPickerView

- (NSMutableArray *)provinces
{
    if (_provinces == nil) {
        _provinces = [[NSMutableArray alloc] init];
    }
    return _provinces;
}


- (NSMutableArray *)cities
{
    if (_cities == nil) {
        _cities = [[NSMutableArray alloc] init];
    }
    return _cities;
}

@synthesize delegate=_delegate;
@synthesize locate=_locate;

-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

- (instancetype)init
{
    if (self = [super init]) {
        UIPickerView *locatePicker = [UIPickerView new];
        locatePicker.backgroundColor = [UIColor whiteColor];
        [self addSubview:locatePicker];
        self.locatePicker = locatePicker;
        self.locatePicker.delegate = self;
        NSArray *data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"zycity.plist" ofType:nil]];
        [self.provinces addObjectsFromArray:data];
        [self.cities addObjectsFromArray:[[self.provinces objectAtIndex:0] objectForKey:@"cities"]];
        
        self.locate.state = [[self.provinces objectAtIndex:0] objectForKey:@"state"];
        self.locate.city = [self.cities objectAtIndex:0];
        
    }
    return self;
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.provinces.count;
            break;
        case 1:
        {
            NSUInteger count = self.cities.count;
            
            return count;
            break;
        }
        default:
            return 0;
            break;
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *text = nil;
    switch (component) {
        case 0:
            text = [[[self.provinces objectAtIndex:row] objectForKey:@"state"] description];
            break;
        case 1:
        {
            id rs = [self.cities objectAtIndex:row];
            if ([rs isKindOfClass:[NSString class]]) {
                text = rs;
            }
            break;
        }
    }
    label.text = text;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 80;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
        switch (component) {
            case 0:
            {
                self.cities = [NSMutableArray arrayWithArray:[[self.provinces objectAtIndex:row] objectForKey:@"cities"]];
                NSString *city = [[self.provinces objectAtIndex:row] objectForKey:@"state"];
                if (_cities.count) {
                    if ([city isEqualToString:@"北京"] || [city isEqualToString:@"上海"] || [city isEqualToString:@"天津"] || [city isEqualToString:@"重庆"])
                    [self.cities insertObject:@"不限" atIndex:0];
                }
                [self.locatePicker reloadComponent:1];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                
                self.locate.state = [[self.provinces objectAtIndex:row] objectForKey:@"state"];
                if (self.cities.count) {
                    self.locate.city = [self.cities objectAtIndex:0];;
                }
                break;
            }
            case 1:
                self.locate.city = [self.cities objectAtIndex:row];
                break;
            default:
                break;
        }

}


#pragma mark - animation
-(UIToolbar *)toolbar{
    if (_toolbar) {
        return _toolbar;
    }
    UIToolbar *toolbar=[[UIToolbar alloc] init];
     toolbar.clipsToBounds = YES;
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.titleLabel.font = [UIFont systemFontOfSize:16];
    [left setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [left setTitle:@"      取消      " forState:UIControlStateNormal];
    [left sizeToFit];
    [left addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lefttem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.titleLabel.font = [UIFont systemFontOfSize:16];
    [right setTitleColor:[Tools getColor:@"fc6e51"] forState:UIControlStateNormal];
    [right setTitle:@"      确定     " forState:UIControlStateNormal];
    [right sizeToFit];
    [right addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    toolbar.items=@[lefttem, centerSpace, rightItem];
    _toolbar = toolbar;
    return _toolbar;
}
- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, kScreenHeight + KToolBarHeight, kScreenWidth, KPickerHeght);
    
    [view addSubview:self];
    self.toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, KToolBarHeight);
    
    [view addSubview:self.toolbar];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.toolbar.frame = CGRectMake(0, kScreenHeight - KPickerHeght - KToolBarHeight, kScreenWidth, KToolBarHeight);
        self.frame = CGRectMake(0, kScreenHeight - KPickerHeght, kScreenWidth, KPickerHeght);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, kScreenHeight + KToolBarHeight, kScreenWidth, KPickerHeght);
                         self.toolbar.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, KToolBarHeight);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [self.toolbar removeFromSuperview];
                     }];
    
}

- (void)removeFromWindow
{
    if (_toolbar) {
        [_toolbar removeFromSuperview];
    }
    [self removeFromSuperview];
}

- (void)removeFromSuperview
{
    [_toolbar removeFromSuperview];
    [super removeFromSuperview];
}

- (void)remove
{
    if ([self.delegate respondsToSelector:@selector(pickerCancle)]) {
        [self.delegate pickerCancle];
    }
    [self cancelPicker];
}

- (void)doneClick
{
    NSLog(@"%@  %@",self.locate.city, self.locate.state);
    if ([self.delegate respondsToSelector:@selector(pickerDoneClick:)]) {
        [self.delegate pickerDoneClick:self];
    }
    [self cancelPicker];
}

@end
