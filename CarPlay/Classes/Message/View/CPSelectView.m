//
//  CPSelectView.m
//  CarPlay
//
//  Created by chewan on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSelectView.h"
#import "ZYPickView.h"
#import "ZHPickView.h"

@interface CPSelectView ()<ZHPickViewDelegate>

@property (nonatomic, strong) ZHPickView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstArrow;
@property (weak, nonatomic) IBOutlet UIButton *secondArrow;
@property (nonatomic, weak) UIButton *lastArrow;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *authoCarSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *carLevelSeg;

@end


@implementation CPSelectView

+ (instancetype)selectView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CPSelectView" owner:nil options:nil] lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

/**
 *  进行初始化设置
 */
- (void)setUp
{
    self.width = kScreenWidth;
    self.height = 360;
    self.y = kScreenHeight;
    self.x = 0;
    
    self.cancleBtn.layer.cornerRadius = 3;
    self.cancleBtn.clipsToBounds = YES;
    
    self.confirmBtn.layer.cornerRadius = 3;
    self.confirmBtn.clipsToBounds = YES;
}

#pragma mark - 显示和隐藏方法
- (void)showWithView:(UIView *)view
{
    [view addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.y = kScreenHeight - 360;
    }];
}

- (void)dismissWithCompletion:(void (^)())completion
{
    [UIView animateWithDuration:0.25 animations:^{
        self.y = kScreenHeight;
    }completion:^(BOOL finished) {
        [self.superview setHidden:YES];
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - 处理点击细节

- (IBAction)arrowClick:(UIButton *)sender {
    
    if (self.lastArrow.tag == sender.tag) {
        if (sender.tag == 1) {
            self.firstArrow.transform = CGAffineTransformIdentity;
        }else{
            self.secondArrow.transform = CGAffineTransformIdentity;
        }
        [self.pickerView remove];
        self.lastArrow = nil;
        return;
    }
    self.lastArrow = sender;
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    if (sender.tag == 2) {
        self.firstArrow.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.25 animations:^{
            self.secondArrow.transform = CGAffineTransformRotate(self.secondArrow.transform, M_PI_2);
        }];
        self.pickerView = [[ZHPickView alloc] initPickviewWithArray:@[@"代驾", @"吃饭", @"唱歌", @"拼车", @"旅行", @"看电影", @"运动"] isHaveNavControler:NO];
        self.pickerView.tag = 2;
        self.pickerView.delegate = self;
        [self.pickerView show];
        
    }else{
        self.secondArrow.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.25 animations:^{
            self.firstArrow.transform = CGAffineTransformRotate(self.secondArrow.transform, M_PI_2);
        }];
        self.pickerView =[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
        self.pickerView.delegate = self;
        [self.pickerView show];
    }
}

- (IBAction)cancleBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectViewCancleBtnClick:)]) {
         [self dismissWithCompletion:nil];
        [self.delegate selectViewCancleBtnClick:self];
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    
    CPSelectViewModel *model = [[CPSelectViewModel alloc] init];
    if (![self.typeLabel.titleLabel.text isEqualToString:@"不限"]){
        model.type = self.typeLabel.titleLabel.text;
    }
    
    if (![self.areaLabel.titleLabel.text isEqualToString:@"不限"]) {
        NSArray *subAddress = [self.areaLabel.titleLabel.text componentsSeparatedByString:@","];
        if (subAddress.count == 3) {
            model.city = subAddress[1];
            model.district = [subAddress lastObject];
        }else{
            model.city = [subAddress firstObject];
            model.district = [subAddress lastObject];
        }
    }
   
    if (self.genderSeg.selectedSegmentIndex == 0) {
        model.gender = @"男";
    }else if (self.genderSeg.selectedSegmentIndex == 1){
        model.gender = @"女";
    }
    
    if (self.authoCarSeg.selectedSegmentIndex == 0) {
        model.authenticate = 1;
    }else if (self.authoCarSeg.selectedSegmentIndex == 1){
        model.authenticate = 0;
    }
    
    if (self.carLevelSeg.selectedSegmentIndex == 0) {
        model.carLevel = @"normal";
    }else if (self.carLevelSeg.selectedSegmentIndex == 1){
        model.carLevel = @"good";
    }
    NSLog(@"%@",model.keyValues);
    if ([self.delegate respondsToSelector:@selector(selectView:finishBtnClick:)]) {
        [self dismissWithCompletion:nil];
        [self.delegate selectView:self finishBtnClick:model];
    }
}

#pragma mark - 处理pickerView
/**
 *  处理picker收回
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pickerView remove];
}

- (void)toobarDonBtnHaveClick:(ZYPickView *)pickView resultString:(NSString *)resultString
{
    if (pickView.tag == 2) {
        [self.typeLabel setTitle:resultString forState:UIControlStateNormal];
        self.secondArrow.transform = CGAffineTransformIdentity;
    }else{
        [self.areaLabel setTitle:resultString forState:UIControlStateNormal];
        self.firstArrow.transform = CGAffineTransformIdentity;
    }
    [self.pickerView remove];
}

@end

@implementation CPSelectViewModel

- (instancetype)init
{
    if (self = [super init]) {
        self.authenticate = -1;
    }
    return self;
}

@end

