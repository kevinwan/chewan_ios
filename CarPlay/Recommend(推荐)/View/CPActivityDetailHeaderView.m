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
@property (nonatomic, strong) NSDictionary *attrbuite;
@end
@implementation CPActivityDetailHeaderView

- (NSDictionary *)attrbuite
{
    if (_attrbuite == nil) {
        NSMutableDictionary *attrbuites = [NSMutableDictionary dictionary];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:7];
        attrbuites[NSFontAttributeName] = ZYFont12;
        attrbuites[NSParagraphStyleAttributeName] = paragraphStyle;
        _attrbuite = [attrbuites copy];
    }
    return _attrbuite;
}

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
    [self.iconView zySetImageWithUrl:model.organizer.avatar placeholderImage:CPPlaceHolderImage forState:UIControlStateNormal];
    self.nameLabel.text = model.organizer.nickname;
    self.titleLabel.attributedText = model.titleAttrText;

    [self.photoView zy_setImageWithUrl:model.covers.firstObject];
    
    if (model.limitType == 0) {
        
        self.partLabel.hidden = NO;
        self.male.hidden = YES;
        self.maleLabel.hidden = YES;
        self.female.hidden = YES;
        self.femaleLabel.hidden = YES;
        NSTextAttachment *attachMent = [[NSTextAttachment alloc] init];
        attachMent.image = [UIImage imageNamed:@"icon_person_gray"];
        attachMent.bounds = CGRectMake(0, -4, 16,16 );
        NSAttributedString *attr = [NSAttributedString attributedStringWithAttachment:attachMent];
        NSMutableAttributedString *partNum = [[NSMutableAttributedString alloc] init];
        [partNum appendAttributedString:attr];
        [partNum appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %zd / 人数不限", model.nowJoinNum]]];
        self.partLabel.attributedText = partNum;
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
    self.createTimeLabel.text = model.createTimeStr;
    
    if (model.subsidyPrice) {

        NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f元/人",model.price]];
        
        NSAttributedString *subPrice = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (现在报名立减%.1f元! )",model.subsidyPrice] attributes: @{NSForegroundColorAttributeName : [Tools getColor:@"fe5967"]}];
        [priceStr appendAttributedString:subPrice];
        self.priceLabel.attributedText = [priceStr copy];
    }else{
        if (model.price) {
            self.priceLabel.text = [NSString stringWithFormat:@"%.1f元/人",model.price];
        }else{
            self.priceLabel.text = @"免费";
        }
    }
    self.startLabel.text = model.startStr;
    self.endLabel.text = model.endStr;
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@",model.destination[@"city"],model.destination[@"district"],model.destination[@"detail"]];
    
    [self.addressLabel setText:address];
    self.descLabel.attributedText = [[NSAttributedString alloc] initWithString:model.instruction attributes:self.attrbuite];
    
    self.height = 692 + ZYScreenWidth / 64.0 * 30.0 - 150;
}

- (IBAction)openDetailLabel:(UIButton *)sender {
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:7];
    sender.selected = !sender.isSelected;
    if (sender.selected) {
         CGSize contentSize = [self.descLabel.text boundingRectWithSize:CGSizeMake(ZYScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:self.attrbuite context:NULL].size;
        self.descHCons.constant = contentSize.height + 14;
    }else{
        self.descHCons.constant = 109;
    }
    
    self.height = 692 + self.descHCons.constant - 109 + ZYScreenWidth / 64.0 * 30.0 - 150;
    [self superViewWillRecive:CPActivityDetailHeaderDetailOpenKey info:nil];
}

@end
