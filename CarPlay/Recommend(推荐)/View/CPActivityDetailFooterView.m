//
//  CPActivityDetailFooter.m
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityDetailFooterView.h"
#import "AFNetworking.h"
#import "ChatViewController.h"
#import "CPLoadingButton.h"

@interface CPActivityDetailFooterView()
@property (weak, nonatomic) IBOutlet UILabel *activityPathLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityPathLCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityPathTopCons;

@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explainLCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explainTopCons;
@property (weak, nonatomic) IBOutlet UIButton *comePartBtn;
@property (weak, nonatomic) IBOutlet UILabel *pathTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *explainTipLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2TopCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1TopCons;
@property (weak, nonatomic) IBOutlet UIButton *byTheTicketButton;
@property (weak, nonatomic) IBOutlet UIButton *toGroupChatButton;
@property (weak, nonatomic) IBOutlet UIButton *openDescButton;
@property (weak, nonatomic) IBOutlet UIButton *openExtraButton;

@end

@implementation CPActivityDetailFooterView

- (void)awakeFromNib
{
    self.explainLabel.preferredMaxLayoutWidth = ZYScreenWidth - 20;
    self.activityPathLabel.preferredMaxLayoutWidth = ZYScreenWidth - 20;
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = [Tools getColor:@"f7f7f7"];
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pathTipLabel.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = [Tools getColor:@"f7f7f7"];
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explainTipLabel.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
}

+ (instancetype)activityDetailFooterView
{
    return [[NSBundle mainBundle] loadNibNamed:@"CPActivityDetailFooterView" owner:nil options:nil].lastObject;
}

- (void)setModel:(CPRecommendModel *)model
{
    _model = model;
    
    self.openDescButton.hidden = !model.desc.trimLength;
    self.openExtraButton.hidden = !model.extraDesc.trimLength;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    self.activityPathLabel.attributedText = [[NSAttributedString alloc] initWithString:model.desc attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    self.explainLabel.attributedText = [[NSAttributedString alloc] initWithString:model.extraDesc attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    if (model.isMember){
        if (model.price) {
            self.comePartBtn.hidden = YES;
            self.byTheTicketButton.hidden = NO;
            self.toGroupChatButton.hidden = NO;
        }else{
            self.comePartBtn.hidden = NO;
            [self.comePartBtn setTitle:@"进入群聊" forState:UIControlStateNormal];
            [self.comePartBtn setBackgroundColor:[Tools getColor:@"F48C60"]];
            self.byTheTicketButton.hidden = YES;
            self.toGroupChatButton.hidden = YES;
        }
    }else{
        self.comePartBtn.hidden = NO;
        [self.comePartBtn setTitle:@"报名参加" forState:UIControlStateNormal];
        [self.comePartBtn setBackgroundColor:RedColor];
        self.byTheTicketButton.hidden = YES;
        self.toGroupChatButton.hidden = YES;
    }


}

- (IBAction)activityPathClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        CGSize contentSize = [self.activityPathLabel.attributedText boundingRectWithSize:CGSizeMake(ZYScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.activityPathLCons.constant = contentSize.height + 2;
        self.activityPathTopCons.constant = 13;
        self.line1TopCons.constant = 20;
        self.activityPathLabel.hidden = NO;
    }else{
        self.activityPathLabel.hidden = YES;
        self.activityPathLCons.constant = 0;
        self.activityPathTopCons.constant = 0;
        self.line1TopCons.constant = 0;
    }
    [self layoutIfNeeded];
    self.height = self.comePartBtn.bottom;
    [self superViewWillRecive:CPActivityFooterViewOpenKey info:nil];
}


- (IBAction)openExplain:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        CGSize contentSize = [self.explainLabel.attributedText boundingRectWithSize:CGSizeMake(ZYScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;

        self.explainLCons.constant = contentSize.height + 2;
        self.explainTopCons.constant = 13;
        self.line2TopCons.constant = 20;
        self.explainLabel.hidden = NO;
    }else{
        self.explainLabel.hidden = YES;
        self.explainLCons.constant = 0;
        self.explainTopCons.constant = 0;
        self.line2TopCons.constant = 0;
    }
    [self layoutIfNeeded];
    self.height = self.comePartBtn.bottom;
    [self superViewWillRecive:CPActivityFooterViewOpenKey info:nil];
}

- (IBAction)loadMoreButtonClick:(CPLoadingButton *)sender {
    [sender startLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender stopLoading];
        [self superViewWillRecive:CPActivityDetailLoadMoreKey info:nil];
    });
}

- (IBAction)comePart:(UIButton *)sender {
  
    CPGoLogin(@"报名参加");
    if ([sender.currentTitle isEqualToString:@"进入群聊"]) {
        [self superViewWillRecive:CPGroupChatClickKey info:_model];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"official/activity/%@/join?userId=%@&token=%@",self.officialActivityId, CPUserId, CPToken];
    [ZYNetWorkTool postJsonWithUrl:url params:nil success:^(id responseObject) {
        if (CPSuccess) {
            [SVProgressHUD showInfoWithStatus:@"申请成功"];
            [self superViewWillRecive:CPJionOfficeActivityKey info:nil];
        }else{
            [SVProgressHUD showInfoWithStatus:CPErrorMsg];
        }
    } failed:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"申请失败"];
    }];
}

- (IBAction)byTheTicket:(id)sender {
    // 进入买票页面
    [self superViewWillRecive:CPGoByTicketClickKey info:_model];
}

- (IBAction)toGroupChat:(id)sender {
    
    // 进入群聊接口
    
    [self superViewWillRecive:CPGroupChatClickKey info:_model];
}

@end
