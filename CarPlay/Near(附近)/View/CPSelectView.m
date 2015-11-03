//
//  CPSelectView.m
//  CarPlay
//
//  Created by chewan on 10/12/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPSelectView.h"
#import "CPNoHighLightButton.h"

@interface CPSelectView ()

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet CPNoHighLightButton *transferBtn;

@property (weak, nonatomic) IBOutlet UIView *typeView;

@property (weak, nonatomic) IBOutlet UIView *payView;

@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewHCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewTopCons;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHCons;

@property (nonatomic, strong) UIButton *lastTypebtn;
@property (nonatomic, weak) UIButton *lastPaybtn;
@property (nonatomic, weak) UIButton *lastSexbtn;
@end

@implementation CPSelectView

- (void)awakeFromNib
{
    self.payViewHCons.constant = 0;
    self.payViewTopCons.constant = 0;
    self.bgViewHCons.constant = 298;
    [self.confirmBtn setCornerRadius:20];
    [self.bgView setCornerRadius:10];
    [self.typeView setCornerRadius:3];
    [self.payView setCornerRadius:3];
    [self.sexView setCornerRadius:3];
    
    ZYNewButton(closeBtn);
    [closeBtn setImage:[UIImage imageNamed:@"icon_close_shaixuan"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    [closeBtn sizeToFit];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-8);
        make.top.equalTo(@10);
    }];
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.alpha = 0.0;
        }completion:^(BOOL finished) {
            [self.superview removeFromSuperview];
        }];
    }];
    
    ZYNewLabel(title);
    title.font = ZYFont16;
    title.text = @"请选择";
    title.textColor = [UIColor whiteColor];
    [title sizeToFit];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@135);
        make.top.equalTo(@8);
    }];
}

+ (void)showWithParams:(ConfirmBtnClick)click
{
    CPSelectView *view = [[NSBundle mainBundle] loadNibNamed:@"CPSelectView" owner:nil options:nil].lastObject;
    
    CPSelectModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:CPSelectModelFilePath];
    
    // 选中筛选的类型
    if (model.type.trimLength){
        for (UIButton *btn in view.typeView.subviews) {
            if ([btn.currentTitle isEqualToString:model.type.noType]) {
                [view typeBtnClick:btn];
                break;
            }
        }
    }else{
        [view typeBtnClick:(UIButton *)[view viewWithTag:3]];
    }
    // 支付方式
    if (model.pay.trimLength) {
        for (UIButton *btn in view.payView.subviews) {
            if ([btn.currentTitle isEqualToString:model.pay]) {
                [view payTypeClick:btn];
                break;
            }
        }
    }else{
        
        [view payTypeClick:(UIButton *)[view viewWithTag:23]];
    }
    if (model.sex.trimLength) {
        for (UIButton *btn in view.sexView.subviews) {
            if ([btn.currentTitle isEqualToString:model.sex]) {
                [view sexBtnClick:btn];
                break;
            }
    }
    }else{
        [view sexBtnClick:(UIButton *)[view viewWithTag:33]];
    }
    view.transferBtn.selected = model.transfer;

    view.click = click;
    ZYNewButton(cover);
    [cover setBackgroundColor:ZYColor(0, 0, 0, 0.5)];
    [ZYKeyWindow addSubview:cover];
    cover.frame = [ZYKeyWindow bounds];
    
    [[cover rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.25 animations:^{
            cover.alpha = 0.0;
        } completion:^(BOOL finished) {
            [cover removeFromSuperview];
        }];
    }];
    
    view.center = cover.center;
    [cover addSubview:view];
    
    cover.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        cover.alpha = 1.0;
    }];
}

#pragma mark - 点击事件
- (IBAction)confrimBtnClick:(id)sender {
    
    CPSelectModel *model = [CPSelectModel new];
    
    if ([self.lastTypebtn.currentTitle isDiffToString:@"不限"]){
        model.type = self.lastTypebtn.currentTitle.type;
    }
    
    if ([self.lastSexbtn.currentTitle isDiffToString:@"不限"]){
        model.sex = self.lastSexbtn.currentTitle;
    }
    if ([self.lastTypebtn.currentTitle isDiffToString:@"运动"] && [self.lastTypebtn.currentTitle isDiffToString:@"遛狗"] && [self.lastTypebtn.currentTitle isDiffToString:@"购物"]) {
        
        model.pay = self.lastPaybtn.currentTitle;
    }
    model.transfer = self.transferBtn.isSelected;
    
    // 保存筛选数据
    ZYAsyncOperation(^{
        [NSKeyedArchiver archiveRootObject:model toFile:CPSelectModelFilePath];
    });
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.alpha = 0;
    }completion:^(BOOL finished) {
        !_click?:_click(model);
        [self.superview removeFromSuperview];
    }];
}
- (IBAction)typeBtnClick:(UIButton *)sender {
    
    if (sender == self.lastTypebtn) {
        return;
    }
    self.lastTypebtn.selected = NO;
    sender.selected = YES;
    self.lastTypebtn = sender;
    if ([sender.currentTitle isEqualToString:@"运动"] || [sender.currentTitle isEqualToString:@"遛狗"] ||[sender.currentTitle isEqualToString:@"购物"] ||
        [sender.currentTitle isEqualToString:@"不限"]) {
        self.payViewHCons.constant = 0;
        self.payViewTopCons.constant = 0;
        self.bgViewHCons.constant = 298;
    }else{
        self.payViewHCons.constant = 42;
        self.payViewTopCons.constant = 10;
        self.bgViewHCons.constant = 350;
    }
}

#pragma mark - 处理按钮切换
- (IBAction)payTypeClick:(UIButton *)sender {
    if (sender == self.lastPaybtn) {
        return;
    }
    self.lastPaybtn.selected = NO;
    sender.selected = YES;
    self.lastPaybtn = sender;
}

- (IBAction)sexBtnClick:(UIButton *)sender {
    self.lastSexbtn.selected = NO;
    sender.selected = YES;
    self.lastSexbtn = sender;
}

- (IBAction)transferBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
@end
