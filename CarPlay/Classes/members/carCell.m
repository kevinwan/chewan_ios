//
//  carCell.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/14.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import "carCell.h"
#import "AppAppearance.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "users.h"
static CGFloat const kBounceValue = 20.0f;
@interface carCell () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *carLog;
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UIButton *mainSeat;

@property (weak, nonatomic) IBOutlet UIView *mycontentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, strong) NSString *totalSeat;

@end

@implementation carCell

- (void)awakeFromNib {
    self.carName.font = [AppAppearance textLargeFont];
    self.carName.textColor = [AppAppearance textDarkColor];
    self.carName.preferredMaxLayoutWidth = 75;
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.mycontentView addGestureRecognizer:self.pan];
    //设置手势代理
    self.pan.delegate = self;
    [self setupButton:@[self.seatMain,self.seatone, self.seatTwo,self.seatThree,self.seatLastOne,self.seatLastTwo,self.seatLastThree]];
  
}
//button需要设置imageView才美观
- (void)setupButton:(NSArray *)buttons {
    for (UIButton *button in buttons) {
        button.imageView.layer.cornerRadius = 11;
        [button clipsToBounds];
        button.imageEdgeInsets = UIEdgeInsetsMake(-4, 4, 8, 4);
    }
}
- (void)removeImageOfButton:(NSArray *)buttons {
    for (UIButton *button in buttons) {
        [button setImage:nil forState:UIControlStateNormal];
    }
}
- (void)setModels:(cars *)models {
    _models = models;
    //设置初始座位头像图片为nil
    [self removeImageOfButton:@[self.seatMain,self.seatone, self.seatTwo,self.seatThree,self.seatLastOne,self.seatLastTwo,self.seatLastThree]];
    NSURL *url = [NSURL URLWithString:_models.carBrandLogo];
    [self.carLog sd_setImageWithURL:url];
    self.carName.text = [NSString stringWithFormat:@"%@",_models.carModel];
    self.totalSeat = _models.totalSeat;
    switch ([self.totalSeat intValue]) {
        case 2:
            self.seatLastThree.hidden = YES;
            self.seatLastTwo.hidden = YES;
            self.seatLastOne.hidden = YES;
            self.seatThree.hidden  = YES;
            self.seatTwo.hidden = YES;
            break;
        case 3:
            self.seatLastThree.hidden = YES;
            self.seatLastTwo.hidden = YES;
            self.seatLastOne.hidden = YES;
            self.seatThree.hidden  = YES;
            break;
        case 4:
            self.seatLastThree.hidden = YES;
            self.seatLastTwo.hidden = YES;
            self.seatLastOne.hidden = YES;
            break;
        case 5:
            self.seatLastOne.hidden = YES;
            self.seatLastTwo.hidden = YES;
            break;
        case 6:
            self.seatLastOne.hidden = YES;
            break;
  
        default:
            break;
    }
    //显示座位的头像
    NSArray *userArray = _models.users;
    for (users *user in userArray) {
        switch ([user.seatIndex intValue]) {
            case 0:
                [self.seatMain sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                break;
            case 1:
                [self.seatone sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                break;
            case 2:
                [self.seatTwo sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                break;
            case 3:
                [self.seatThree sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                break;
            case 4:
                [self.seatLastThree sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                break;
            case 5:
                [self.seatLastTwo sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                break;
            case 6:
                [self.seatLastOne sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                break;
                
            default:
                break;
        }
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
                CGFloat halfofButtonOne = CGRectGetWidth(self.seatLastThree.frame);
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
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.seatLastThree.frame);
}

#pragma mark - 手势相关

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
