//
//  CPNewMessageCell.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNewMessageCell.h"
#import "CPNewMsgModel.h"

@interface CPNewMessageCell()
@property (nonatomic, strong) UIImageView *checkImageView;
// 显示图像的区域
@property (weak, nonatomic) IBOutlet UIButton *iconView;
// 显示姓名的label
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
// 显示性别的区域
@property (weak, nonatomic) IBOutlet UIButton *sexView;
// 用户描述的label
@property (weak, nonatomic) IBOutlet UILabel *descripteLable;

@end

@implementation CPNewMessageCell

- (void)awakeFromNib {
    
    self.descripteLable.preferredMaxLayoutWidth = kScreenWidth - 80;
    
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        DLog(@"%@",recognizer);
        [self removeGestureRecognizer:recognizer];
    }
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}

- (void)setModel:(CPNewMsgModel *)model
{
    _model = model;
    
    [self setChecked:model.isChecked];
    
    self.descripteLable.text = [NSString stringWithFormat:@"你没的黄随碟附送打法是否打开撒旦;发了卡仕达; 是东风科技阿斯利康大家阿里开发商记录卡双方的家里看范德是%zd号changialsjdfkladsjkldajsflkdfsjlkdsjfldfsjldfsajlkj我👌👌👌",arc4random_uniform(100)];
    
    self.nameLable.text = [NSString stringWithFormat:@"我是NB%zd号",arc4random_uniform(100)];
    
    [self layoutIfNeeded];
    
    self.cellHeight = self.descripteLable.bottom + 10;
    
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        DLog(@"发一次通知");
        [CPNotificationCenter postNotificationName:CPNewMsgEditNotifycation object:nil userInfo:@{CPNewMsgEditInfo : @(self.model.row)}];
    }
}

#pragma mark - 可以多选的tableView

- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        self.checkImageView.center = pt;
        self.checkImageView.alpha = alpha;
        
        [UIView commitAnimations];
    }
    else
    {
        self.checkImageView.center = pt;
        self.checkImageView.alpha = alpha;
    }
}


- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    if (self.editing == editting)
    {
        return;
    }
    
    [super setEditing:editting animated:animated];
    
    if (editting)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        if (self.checkImageView == nil)
        {
            self.checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unselected"]];
            [self addSubview:self.checkImageView];
        }
        
        [self setChecked:_checked];
        self.checkImageView.center = CGPointMake(-CGRectGetWidth(self.checkImageView.frame) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
        self.checkImageView.alpha = 0.0;
        [self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5) alpha:1.0 animated:animated];
    }
    else
    {
        _checked = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = nil;
        
        if (self.checkImageView)
        {
            [self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(self.checkImageView.frame) * 0.5, CGRectGetHeight(self.bounds) * 0.5) alpha:0.0 animated:animated];
        }
    }
}

- (void)dealloc
{
    self.checkImageView = nil;
}


- (void) setChecked:(BOOL)checked
{
    if (checked)
    {
        self.checkImageView.image = [UIImage imageNamed:@"选中照片"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        self.checkImageView.image = [UIImage imageNamed:@"Unselected.png"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    _checked = checked;
}

@end
