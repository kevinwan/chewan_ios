//
//  CPNearViewCell.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNearViewCell.h"

@implementation CPNearViewCell

- (void)setFrame:(CGRect)frame
{
    CGRect newF = frame;
    newF.origin.y += 40;
    [super setFrame:newF];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    CPNearViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        
        DLog(@"疯狂创建啊啊啊啊啊啊啊");
        cell = [[NSBundle mainBundle] loadNibNamed:@"CPNearViewCell" owner:nil options:nil].lastObject;
        cell.width = ZYScreenWidth;
    }
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    return cell;
//     [UINib nibWithNibName:@"CPNearViewCell" bundle:nil]
}
- (IBAction)he:(id)sender {
    [self.nextResponder superViewWillRecive:@"来不来" info:@"he"];
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//    
//        
//    }
//    return self;
//}

@end
