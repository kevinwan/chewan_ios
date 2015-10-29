//
//  CPComeOnTipView.m
//  CarPlay
//
//  Created by chewan on 10/20/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPComeOnTipView.h"

@interface CPComeOnTipView()
@property (weak, nonatomic) IBOutlet UIButton *transfer;


@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendComeOnBtn;
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *targetUserId;
@end

@implementation CPComeOnTipView

- (void)awakeFromNib
{
    [self setCornerRadius:10];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = [Tools getColor:@"efefef"].CGColor;
    UIView *leftView = [UIView new];
    leftView.width = 16;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftView;
    [self.textField setCornerRadius:17];
    [self.sendComeOnBtn setCornerRadius:20];
    
    [[ZYNotificationCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification *notify) {
        NSDictionary *userInfo = notify.userInfo;
        
        CGRect rect = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        
        CGFloat offset = rect.origin.y -  self.bottom ;
        if (offset < 0) {
            [UIView animateWithDuration:0.25 animations:^{
                self.y += offset;
            }];
        }
        
    }];
    
    [[ZYNotificationCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification *notify) {
        if (self.centerY != ZYScreenHeight * 0.5) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.centerY = ZYScreenHeight * 0.5;
            }];
        }
        
    }];
}

- (IBAction)transferBtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
- (IBAction)sendComeOnClick:(UIButton *)sender {
    NSString *url = [NSString stringWithFormat:@"official/activity/%@/invite?userId=%@&token=%@",self.activityId,CPUserId, CPToken];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"invitedUserId"] = self.targetUserId;
    
    if (sender.selected) {
        params[@"transfer"] = @(NO);
    }else{
        params[@"transfer"] = @(YES);
    }
    params[@"message"] = self.textField.text;

    [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        if (CPSuccess) {
            [SVProgressHUD showInfoWithStatus:@"邀请已发出"];
            [UIView animateWithDuration:0.25 animations:^{
                self.superview.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.superview removeFromSuperview];
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:CPErrorMsg];
        }
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showInfoWithStatus:@"邀请失败"];
    }];
}

+ (void)showWithActivityId:(NSString *)activityId targetUserId:(NSString *)targetUserId
{
    ZYNewButton(cover);
    [cover setBackgroundColor:ZYColor(0, 0, 0, 0.5)];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:cover];
    cover.frame = [keyWindow bounds];
    [[cover rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.25 animations:^{
            cover.alpha = 0.0;
        } completion:^(BOOL finished) {
            [cover removeFromSuperview];
        }];
    }];
    CPComeOnTipView *view = [[NSBundle mainBundle] loadNibNamed:@"CPComeOnTipView" owner:nil options:nil].lastObject;
    view.activityId = activityId;
    view.targetUserId = targetUserId;
    view.center = cover.centerInSelf;
    [cover addSubview:view];
    cover.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        cover.alpha = 1.0;
    }];
}

@end
