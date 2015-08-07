//
//  CPNewMessageCell.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNewMessageCell.h"
#import "CPNewMsgModel.h"
#import "CPSexView.h"
#import "UIButton+WebCache.h"

@interface CPNewMessageCell()
@property (nonatomic, strong) UIImageView *checkImageView;
// 显示图像的区域
@property (weak, nonatomic) IBOutlet UIButton *iconView;
// 显示姓名的label
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
// 显示性别的区域
@property (weak, nonatomic) IBOutlet CPSexView *sexView;
// 用户描述的label
@property (weak, nonatomic) IBOutlet UILabel *descripteLable;

@end

@implementation CPNewMessageCell

- (void)awakeFromNib {
    
    self.descripteLable.preferredMaxLayoutWidth = kScreenWidth - 80;
    
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:recognizer];
    }
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(CPNewMsgModel *)model
{
    _model = model;
    
    [self setChecked:model.isChecked];
    
    self.descripteLable.text = model.content;
    
    self.nameLable.text = model.nickname;
    
    self.sexView.isMan = model.isMan;
    self.sexView.age = model.age;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
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
        if (self.checkImageView == nil)
        {
            self.checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未选"]];
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
        self.checkImageView.image = [UIImage imageNamed:@"选中"];
    }
    else
    {
        self.checkImageView.image = [UIImage imageNamed:@"未选"];
    }
    _checked = checked;
}

- (IBAction)iconViewClick:(id)sender {
    if (_model.userId.length) {
        [CPNotificationCenter postNotificationName:CPClickUserIconNotification object:nil userInfo:@{CPClickUserIconInfo : _model.userId}];
    }
}


@end
