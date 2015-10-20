//
//  CPSelectView.m
//  CarPlay
//
//  Created by chewan on 10/12/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPSelectView.h"
#import "CPNoHighLightButton.h"

#define   CPSelectModelFilePath @"selectModel.data".documentPath
@interface CPSelectView ()

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet CPNoHighLightButton *transferBtn;

@property (nonatomic, strong) UIButton *lastTypebtn;
@property (nonatomic, weak) UIButton *lastPaybtn;
@property (nonatomic, weak) UIButton *lastSexbtn;
@property (weak, nonatomic) IBOutlet UIView *typeView;

@property (weak, nonatomic) IBOutlet UIView *payView;

@property (weak, nonatomic) IBOutlet UIView *sexView;

@end

@implementation CPSelectView

- (void)awakeFromNib
{
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
    
    if (model) {
        
        for (UIButton *btn in view.typeView.subviews) {
            if ([btn.currentTitle isEqualToString:model.type]) {
                
                [view typeBtnClick:btn];
                break;
            }
        }
        for (UIButton *btn in view.payView.subviews) {
            if ([btn.currentTitle isEqualToString:model.pay]) {
                
                [view payTypeClick:btn];
                break;
            }
        }
        for (UIButton *btn in view.sexView.subviews) {
            if ([btn.currentTitle isEqualToString:model.sex]) {
                
                [view sexBtnClick:btn];
                break;
            }
        }
        view.transferBtn.selected = model.transfer;
        
    }else{
        
        [view typeBtnClick:(UIButton *)[view viewWithTag:11]];
        [view payTypeClick:(UIButton *)[view viewWithTag:23]];
        [view sexBtnClick:(UIButton *)[view viewWithTag:33]];
    }
    
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
    model.pay = self.lastPaybtn.currentTitle;
    model.sex = self.lastSexbtn.currentTitle;
    model.type = self.lastTypebtn.currentTitle;
    model.transfer = self.transferBtn.isSelected;
    [NSKeyedArchiver archiveRootObject:model toFile:CPSelectModelFilePath];
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.alpha = 0;
    }completion:^(BOOL finished) {
        !_click?:_click(model);
        [self.superview removeFromSuperview];
    }];
}
- (IBAction)typeBtnClick:(UIButton *)sender {
    self.lastTypebtn.selected = NO;
    sender.selected = YES;
    self.lastTypebtn = sender;
}
- (IBAction)payTypeClick:(UIButton *)sender {
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
