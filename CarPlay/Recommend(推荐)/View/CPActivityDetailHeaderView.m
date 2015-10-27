//
//  CPActivityDetailHeaderView.m
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityDetailHeaderView.h"
#import "ZYImageVIew.h"

@interface CPActivityDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@property (weak, nonatomic) IBOutlet ZYImageVIew *photoView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHCons;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *female;
@property (weak, nonatomic) IBOutlet UILabel *femaleLabel;
@property (weak, nonatomic) IBOutlet UIButton *male;

@property (weak, nonatomic) IBOutlet UILabel *maleLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipPartLabel;

@end
@implementation CPActivityDetailHeaderView

+ (instancetype)activityDetailHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:@"CPActivityDetailHeaderView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [self.iconView setCornerRadius:15];
    self.titleLabel.preferredMaxLayoutWidth = ZYScreenWidth - 20;
    self.descLabel.preferredMaxLayoutWidth = ZYScreenWidth - 20;
}

-  (void)setModel:(CPRecommendModel *)model
{
    _model = model;
    if (model.title.length == 0) {
        return;
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.organizer.avatar] forState:UIControlStateNormal placeholderImage:CPPlaceHolderImage];
    self.nameLabel.text = model.organizer.nickname;
    self.titleLabel.attributedText = model.titleAttrText;

    [self.photoView zy_setImageWithUrl:model.covers.firstObject];
    
    if (model.limitType == 0) {
        
        self.partLabel.hidden = NO;
        self.male.hidden = YES;
        self.maleLabel.hidden = YES;
        self.female.hidden = YES;
        self.femaleLabel.hidden = YES;
        self.partLabel.text = @"无限制";
    }else if (model.limitType == 1){
        
        self.partLabel.hidden = NO;
        self.male.hidden = YES;
        self.maleLabel.hidden = YES;
        self.female.hidden = YES;
        self.femaleLabel.hidden = YES;
        self.partLabel.attributedText = model.joinPersonText;
    }else if (model.limitType == 2){
        
        self.partLabel.hidden = YES;
        self.male.hidden = NO;
        self.maleLabel.hidden = NO;
        self.female.hidden = NO;
        self.femaleLabel.hidden = NO;
        
        self.maleLabel.text = [NSString stringWithFormat:@"%zd / %zd",model.maleNum,model.maleLimit];
        self.femaleLabel.text = [NSString stringWithFormat:@"%zd / %zd",model.femaleNum,model.femaleLimit];
    }
    
    if (model.subsidyPrice) {
        
        NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithAttributedString:model.priceText];
        
        NSAttributedString *subPrice = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (现在报名力减%f元)",model.subsidyPrice] attributes: @{NSForegroundColorAttributeName : [Tools getColor:@"fe5967"]}];
        [priceStr appendAttributedString:subPrice];
        self.priceLabel.attributedText = [priceStr copy];
    }else{
        self.priceLabel.attributedText = model.priceText;
    }
    self.startLabel.text = model.startStr;
    self.endLabel.text = model.endStr;
    [self.addressLabel setText:model.destination[@"detail"]];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    self.descLabel.attributedText = [[NSAttributedString alloc] initWithString:model.instruction attributes:@{NSParagraphStyleAttributeName : paragraphStyle1}];
    
    self.height = 701 + ZYScreenWidth / 64.0 * 30.0 - 150;
}

- (IBAction)openDetailLabel:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        
        
        CGSize contentSize = [self.descLabel.attributedText boundingRectWithSize:CGSizeMake(ZYScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.descHCons.constant = contentSize.height + 20;
    }else{
        self.descHCons.constant = 109;
    }
    
    self.height = 701 + self.descHCons.constant - 109 + ZYScreenWidth / 64.0 * 30.0 - 150;
    [self superViewWillRecive:CPActivityDetailHeaderDetailOpenKey info:nil];
}


@end
