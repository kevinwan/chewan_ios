//
//  CPActivityDetailFooter.m
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityDetailFooterView.h"
#import "AFNetworking.h"


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
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    self.activityPathLabel.attributedText = [[NSAttributedString alloc] initWithString:model.desc attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    self.explainLabel.attributedText = [[NSAttributedString alloc] initWithString:model.extraDesc attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
}

- (IBAction)activityPathClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        CGSize contentSize = [self.activityPathLabel.attributedText boundingRectWithSize:CGSizeMake(ZYScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.activityPathLCons.constant = contentSize.height + 2;
        self.activityPathTopCons.constant = 13;
        self.line1TopCons.constant = 20;
    }else{
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
    }else{
        self.explainLCons.constant = 0;
        self.explainTopCons.constant = 0;
        self.line2TopCons.constant = 0;
    }
    [self layoutIfNeeded];
    self.height = self.comePartBtn.bottom;
    [self superViewWillRecive:CPActivityFooterViewOpenKey info:nil];
}


- (IBAction)comePart:(UIButton *)sender {
  
    NSString *url = [NSString stringWithFormat:@"official/activity/%@/join?userId=%@&token=%@",self.officialActivityId, CPUserId, CPToken];
//    [SVProgressHUD showWithStatus:@"努力加载中"];
//    NSDictionary *params = @{@"userId":CPUserId, @"token":CPToken};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,url] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
//    [ZYNetWorkTool postJsonWithUrl:url params:nil success:^(id responseObject) {
//        
//    } failed:^(NSError *error) {
//        
//    }];
//    [ZYNetWorkTool postWithUrl:url params:nil success:^(id responseObject) {
//        if (CPSuccess) {
//            [SVProgressHUD showInfoWithStatus:@"报名成功"];
//            [sender setBackgroundColor:[Tools getColor:@"999999"]];
//            [self superViewWillRecive:CPActivityComePartKey info:nil];
//        }else{
//            
//            [SVProgressHUD showInfoWithStatus:@"报名失败"];
//        }
//    } failure:^(NSError *error) {
//        
//        [SVProgressHUD showInfoWithStatus:@"加载失败"];
//    }];
    
}

@end
