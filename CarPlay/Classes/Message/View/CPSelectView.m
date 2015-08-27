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
#import "ZYSegmentControl.h"
#define CPSelectModelPath CPDocmentPath([[Tools getValueFromKey:@"userId"] stringByAppendingString:@"CPSelectModel.data"])
@interface CPSelectView ()<ZHPickViewDelegate>

@property (nonatomic, strong) ZHPickView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstArrow;
@property (weak, nonatomic) IBOutlet UIButton *secondArrow;
@property (nonatomic, weak) UIButton *lastArrow;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet ZYSegmentControl *genderSeg;
@property (weak, nonatomic) IBOutlet ZYSegmentControl *authoCarSeg;
@property (weak, nonatomic) IBOutlet ZYSegmentControl *carLevelSeg;

@end


@implementation CPSelectView

- (void)awakeFromNib
{
    self.genderSeg.items = @[@"男生", @"女生", @"不限"];
    self.authoCarSeg.items = @[@"车主", @"非车主", @"不限"];
    self.carLevelSeg.items = @[@"一般", @"好车", @"不限"];

    self.cancleBtn.layer.cornerRadius = 3;
    self.cancleBtn.clipsToBounds = YES;
    
    self.confirmBtn.layer.cornerRadius = 3;
    self.confirmBtn.clipsToBounds = YES;
}

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

/**
 *  进行初始化设置
 */
- (void)setUp
{
    self.width = kScreenWidth;
    self.height = 360;
    self.y = kScreenHeight;
    self.x = 0;
    
    [CPNotificationCenter addObserver:self selector:@selector(canclePicker:) name:@"remove" object:nil];
}

#pragma mark - 显示和隐藏方法
- (void)showWithView:(UIView *)view
{
    [view addSubview:self];
    
    if (CPIsLogin) {
        
        [self loadData];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.y = view.height - 360;
    }];
}

- (void)dismissWithCompletion:(void (^)())completion
{
    // 移除selectView的时候删除pickerView
    if (self.pickerView) {
        [self.pickerView removeFromSuperview];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.y = kScreenHeight;
    }completion:^(BOOL finished) {
        [self.superview setHidden:YES];
        [CPNotificationCenter removeObserver:self];
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - 加载缓存数据
- (void)loadData
{
    CPSelectViewModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:CPSelectModelPath];
    if (model) {
        
        // 设置类型
        if (model.type.length) {
            [self.typeLabel setTitle:model.type forState:UIControlStateNormal];
        }else{
            [self.typeLabel setTitle:@"不限" forState:UIControlStateNormal];
        }
        
        // 设置性别
        if ([model.gender isEqualToString:@"男"]){
            self.genderSeg.selectedSegmentIndex = 0;
        }else if ([model.gender isEqualToString:@"女"]){
            self.genderSeg.selectedSegmentIndex = 1;
        }else{
            self.genderSeg.selectedSegmentIndex = 2;
        }
        
        
        // 设置是否车主
        if (model.authenticate == 1) {
            self.authoCarSeg.selectedSegmentIndex = 0;
        }else if (model.authenticate == 0){
            self.authoCarSeg.selectedSegmentIndex = 1;
        }else{
            self.authoCarSeg.selectedSegmentIndex = 2;
        }
        
        // 设置是否好车
        if ([model.carLevel isEqualToString:@"normal"]) {
            self.carLevelSeg.selectedSegmentIndex = 0;
        }else if ([model.carLevel isEqualToString:@"good"]){
            self.carLevelSeg.selectedSegmentIndex = 1;
        }else{
            self.carLevelSeg.selectedSegmentIndex = 2;
        }
        
    }
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
        self.pickerView = [[ZHPickView alloc] initPickviewWithArray:@[@"吃饭", @"唱歌", @"看电影", @"周边游", @"运动", @"拼车", @"购物", @"亲子游", @"不限"]isHaveNavControler:NO];
        [self.pickerView setTintColor:[Tools getColor:@"fc6e51"]];
        self.pickerView.tag = 2;
        self.pickerView.delegate = self;
        [self.pickerView show];
        
    }else{
        self.secondArrow.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.25 animations:^{
            self.firstArrow.transform = CGAffineTransformRotate(self.secondArrow.transform, M_PI_2);
        }];
        self.pickerView =[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
        [self.pickerView setTintColor:[Tools getColor:@"fc6e51"]];
        self.pickerView.delegate = self;
        [self.pickerView show];
    }
}

- (IBAction)cancleBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectViewCancleBtnClick:)]) {
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
            model.province = subAddress[0];
            model.city = subAddress[1];
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
    if ([self.delegate respondsToSelector:@selector(selectView:finishBtnClick:)]) {
        
        [NSKeyedArchiver archiveRootObject:model toFile:CPSelectModelPath];
        
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
    }else{
        [self.areaLabel setTitle:resultString forState:UIControlStateNormal];
    }
}

- (void)canclePicker:(NSNotification *)notify
{
    NSInteger tag = [notify.userInfo[@"info"] intValue];
    if (tag == 2) {
        self.secondArrow.transform = CGAffineTransformIdentity;
    }else{
        self.firstArrow.transform = CGAffineTransformIdentity;
    }
    self.lastArrow = nil;
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
MJCodingImplementation
@end

