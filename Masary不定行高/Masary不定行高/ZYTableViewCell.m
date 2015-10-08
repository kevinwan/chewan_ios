//
//  ZYTableViewCell.m
//  Masary不定行高
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "ZYTableViewCell.h"
#import "Masonry.h"
// 定义这个宏可以使用一些更简洁的方法
#define MAS_SHORTHAND

// 定义这个宏可以使用自动装箱功能
#define MAS_SHORTHAND_GLOBALS

@implementation ZYTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.label = [UILabel new];
        self.label.numberOfLines = 0;
        self.label.font = [UIFont systemFontOfSize:24];
        self.label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 12;
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.left.equalTo(@6);
        }];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    self.label.text = text;
    
    [self layoutIfNeeded];
    
    self.cellHeight = CGRectGetMaxY(self.label.frame) + 5;
}

@end
