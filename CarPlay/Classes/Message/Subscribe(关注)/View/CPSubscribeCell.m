//
//  CPSubscribeCell.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSubscribeCell.h"
#import "CPCancleSubBtn.h"

@interface CPSubscribeCell()

@end

@implementation CPSubscribeCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)cancelSub:(CPCancleSubBtn *)sender {
    sender.selected = !sender.isSelected;
}


@end
