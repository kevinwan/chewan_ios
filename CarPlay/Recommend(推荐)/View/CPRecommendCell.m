//
//  CPRecommendCell.m
//  CarPlay
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPRecommendCell.h"

@interface CPRecommendCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentTextL;
@property (weak, nonatomic) IBOutlet UIImageView *bgTip;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation CPRecommendCell

- (void)awakeFromNib{
    self.contentTextL.preferredMaxLayoutWidth = ZYScreenWidth - 40;

    [self.bgTip addSubview:self.tipLabel];
    self.tipLabel.text = @"官方补贴50元每人";
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero]);
    }];
}

- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = ZYFont12;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

@end
