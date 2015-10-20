//
//  CPActivityPathCell.m
//  CarPlay
//
//  Created by chewan on 10/20/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityPathCell.h"

@interface CPActivityPathCell ()
@property (nonatomic, strong) UILabel *activityPathLabel;
@end

@implementation CPActivityPathCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.activityPathLabel = [[UILabel alloc] init];
        self.activityPathLabel.numberOfLines = 0;
        self.activityPathLabel.font = ZYFont12;
        self.activityPathLabel.textColor = [UIColor blueColor];
        [self.contentView addSubview:self.activityPathLabel];
        self.activityPathLabel.preferredMaxLayoutWidth = ZYScreenWidth - 20;
        [self.activityPathLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@10);
        }];

    }
    return self;
}


- (void)setActivityPathText:(NSString *)activityPathText
{
    _activityPathText = [activityPathText copy];
    
    self.activityPathLabel.text = activityPathText;
    [self layoutIfNeeded];
    self.cellHeight = self.activityPathLabel.bottom + 10;
    
}

@end
