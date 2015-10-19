//
//  CPActivityDetailFooter.m
//  CarPlay
//
//  Created by chewan on 10/19/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityDetailFooterView.h"


@interface CPActivityDetailFooterView()
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explainLCons;
@property (weak, nonatomic) IBOutlet UIButton *comePartBtn;

@end

@implementation CPActivityDetailFooterView

- (void)awakeFromNib
{
    self.explainLabel.preferredMaxLayoutWidth = ZYScreenWidth - 20;
}

+ (instancetype)activityDetailFooterView
{
    return [[NSBundle mainBundle] loadNibNamed:@"CPActivityDetailFooterView" owner:nil options:nil].lastObject;
}

- (IBAction)openExplain:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}


- (IBAction)comePart:(UIButton *)sender {
    [self superViewWillRecive:CPActivityComePartKey info:nil];
}

@end
