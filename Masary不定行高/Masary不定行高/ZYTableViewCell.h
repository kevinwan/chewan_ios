//
//  ZYTableViewCell.h
//  Masary不定行高
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CGFloat cellHeight;
@end
