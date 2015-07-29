//
//  memberCell.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/15.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import "memberManageCell.h"
#import "AppAppearance.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
//手势需要
static CGFloat const kBounceValue = 20.0f;
@interface memberManageCell ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memberIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *carLogImageView;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UIView *mycontentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;

@end

@implementation memberManageCell

- (void)awakeFromNib {
    
    self.titleLabel.font = [AppAppearance textLargeFont];
    self.titleLabel.textColor = [AppAppearance textDarkColor];
    self.subTitleLabel.font = [AppAppearance textMediumFont];
    self.subTitleLabel.textColor = [AppAppearance textMediumColor];
    self.memberIconImageView.layer.cornerRadius = 25;
    self.memberIconImageView.clipsToBounds = YES;
    [self.deleteButton setBackgroundColor:[AppAppearance redColor]];
    [self.deleteButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.mycontentView addGestureRecognizer:self.pan];
    //设置手势代理
    self.pan.delegate = self;
    
}

- (void)setModels:(members *)models {
    _models = models;
    self.titleLabel.text = _models.nickname;
    [self.memberIconImageView sd_setImageWithURL:[NSURL URLWithString:_models.photo]];
    [self.carLogImageView sd_setImageWithURL:[NSURL URLWithString:_models.carBrandLogo]];
    [self.ageButton setTitle:[NSString stringWithFormat:@"%@",_models.age] forState:UIControlStateNormal];
    UIImage *ageimage = nil;
    if ([_models.gender isEqualToString:@"男"]) {
        ageimage = [UIImage imageNamed:@"member_man"];
    } else {
        ageimage = [UIImage imageNamed:@"member_women"];
    }
    [self.ageButton setBackgroundImage:ageimage forState:UIControlStateNormal];
    self.ageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.ageButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
    [self.carLogImageView sd_setImageWithURL:[NSURL URLWithString:_models.carBrandLogo]];
    //将2个两个字变红
    if (_models.carModel.length == 0) {
        self.subTitleLabel.text = @"带我飞~";
    } else {
        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@,%@年驾龄,提供%@个座位",_models.carModel, _models.drivingExperience,_models.seat]];
        [subTitle addAttribute:NSForegroundColorAttributeName value:[AppAppearance redColor] range:NSMakeRange(subTitle.length - 4, 2)];
        self.subTitleLabel.attributedText = subTitle;
    }
    
    
}

#pragma mark - 手势相关

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIPanGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}
- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)endEditing {
    if (self.startingRightLayoutConstraintConstant == 0 && self.rightConstraint.constant == 0) {
        return;
    }
    self.rightConstraint.constant = -kBounceValue;
    self.leftConstraint.constant = kBounceValue;
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.rightConstraint.constant = 0;
        self.leftConstraint.constant = 0;
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.rightConstraint.constant;
        }];
    }];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] && self.rightConstraint.constant == [self buttonTotalWidth]) {
        return;
    }
    self.leftConstraint.constant = - [self buttonTotalWidth]-kBounceValue;
    self.rightConstraint.constant = [self buttonTotalWidth] +kBounceValue;
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.leftConstraint.constant = -[self buttonTotalWidth];
        self.rightConstraint.constant = [self buttonTotalWidth];
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.rightConstraint.constant;
        }];
    }];

}
- (void)pan:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.startPoint = [pan translationInView:self.mycontentView];
            break;
        case UIGestureRecognizerStateChanged:
           self.currentPoint = [pan translationInView:self.mycontentView];
            CGFloat  deltaX = self.currentPoint.x - self.startPoint.x;
            BOOL panningLeft = NO;
            if (self.currentPoint.x < self.startPoint.x) {
                panningLeft = YES;
            }
            if (self.startingRightLayoutConstraintConstant == 0) {
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.rightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.rightConstraint.constant = constant;
                    }
                
                }
            } else {
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX;
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.rightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.rightConstraint.constant = constant;
                    }
                
                }
            
            }
            self.leftConstraint.constant = -self.rightConstraint.constant;
            break;
            
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) {
                CGFloat halfofButtonOne = CGRectGetWidth(self.deleteButton.frame);
                if (self.rightConstraint.constant >= halfofButtonOne) {
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
            
        default:
            break;
    }

}
//获取总共的宽度
- (CGFloat)buttonTotalWidth {
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.deleteButton.frame);
}

#pragma mark - 手势相关



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
