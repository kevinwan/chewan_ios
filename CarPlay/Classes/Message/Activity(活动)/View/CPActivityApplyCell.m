//
//  CPActivityApplyCell.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActivityApplyCell.h"

@interface CPActivityApplyCell()

@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipmsgLabel;

@property (weak, nonatomic) IBOutlet UIButton *sexView;
@property (weak, nonatomic) IBOutlet UIImageView *carView;
@property (weak, nonatomic) IBOutlet UILabel *offerSeatLabel;

@end

@implementation CPActivityApplyCell
- (IBAction)agreebtnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

- (void)awakeFromNib {
    
    
}

/**
 *  设置提供座位的label的text
 */
- (void)setOfferSeatLabelText:(NSString *)text
{
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
//    NSRange range = NSMakeRange(<#NSUInteger loc#>, <#NSUInteger len#>)
//    
//    str addAttribute:<#(NSString *)#> value:<#(id)#> range:<#(NSRange)#>
    
}


@end
