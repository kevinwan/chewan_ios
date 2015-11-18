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

#pragma mark - 各种约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityPathLCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityPathTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explainLCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explainTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2TopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1TopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pathTitleHCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *extraTitleHCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadMoreBtnHCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewCons1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewCons2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewCons3;

/**
 *  展示文字的label
 */
@property (weak, nonatomic) IBOutlet UILabel *pathTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *explainTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPathLabel;

/**
 *  各种交互的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *openDescButton;
@property (weak, nonatomic) IBOutlet UIButton *openExtraButton;
@property (weak, nonatomic) IBOutlet CPLoadingButton *loadMoreBtn;
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
    
    if (model.nowJoinNum > 6) {
        self.loadMoreBtnHCons.constant = 44;
        self.loadMoreBtn.hidden = NO;
    }else{
        self.loadMoreBtnHCons.constant = 0;
        self.loadMoreBtn.hidden = YES;
    }
    
    if (model.desc.trimLength) {
        self.pathTitleHCons.constant = 44;
        self.lineViewCons1.constant = 10;
        self.openDescButton.hidden = NO;
        self.pathTipLabel.hidden = NO;
    }else{
        self.pathTipLabel.hidden = YES;
        self.openDescButton.hidden = YES;
        self.pathTitleHCons.constant = 0;
        self.lineViewCons1.constant = 0;
    }
    
    if (model.extraDesc.trimLength) {
        self.extraTitleHCons.constant = 44;
        self.openExtraButton.hidden = NO;
        self.lineViewCons2.constant = 10;
        self.explainTipLabel.hidden = NO;
    }else{
        self.explainTipLabel.hidden = YES;
        self.openExtraButton.hidden = YES;
        self.lineViewCons2.constant = 0;
        self.extraTitleHCons.constant = 0;
    }
    
    // 设置文本属性 行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    self.activityPathLabel.attributedText = [[NSAttributedString alloc] initWithString:model.desc attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    self.explainLabel.attributedText = [[NSAttributedString alloc] initWithString:model.extraDesc attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];

    [self layoutIfNeeded];
    self.height = self.explainLabel.bottom;
}

/**
 *  展开活动流程
 *
 *  @param sender sender description
 */
- (IBAction)activityPathClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    // 根据按钮状态计算文本高度,调整约束
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
    self.height = self.explainLabel.bottom;
    [self superViewWillRecive:CPActivityFooterViewOpenKey info:nil];
}

/**
 *  展开活动说明
 *
 *  @param sender sender description
 */
- (IBAction)openExplain:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        CGSize contentSize = [self.explainLabel.attributedText boundingRectWithSize:CGSizeMake(ZYScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;

        self.explainLCons.constant = contentSize.height + 12;
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
    self.height = self.explainLabel.bottom;
    [self superViewWillRecive:CPActivityFooterViewOpenKey info:nil];
}

/**
 *  点击加载更多
 */
- (IBAction)loadMoreButtonClick:(CPLoadingButton *)sender {
    [sender startLoading];
    
    ZYAfter(1.0, ^{
        [sender stopLoading];
        [self superViewWillRecive:CPActivityDetailLoadMoreKey info:nil];
    });
}

@end
