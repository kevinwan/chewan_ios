//
//  CPNearViewCell.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNearViewCell.h"

@interface CPNearViewCell ()
/**
 *  背景的View
 */
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CPNearViewCell

// 使cell位置下移20
- (void)setFrame:(CGRect)frame
{
    CGRect newF = frame;
    newF.origin.y += 20;
    [super setFrame:newF];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    CPNearViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CPNearViewCell" owner:nil options:nil].lastObject;
        cell.width = ZYScreenWidth;
        
        cell.bgView.layer.cornerRadius = 5;
        cell.bgView.clipsToBounds = YES;
    }
    return cell;
}
- (IBAction)he:(id)sender {
    [self.nextResponder superViewWillRecive:@"来不来" info:@"he"];
}

- (IBAction)yueTa:(id)sender {
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"中秋提示" message:@"伟业是好淫吗?" delegate:nil cancelButtonTitle:@"可能吗" otherButtonTitles:@"算是吧", nil];
    [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
        if ([x isEqual:@(0)]) {
            NSLog(@"不是啊");
        }else{
            NSLog(@"是");
        }
    }];
    [alert show];
}

@end
