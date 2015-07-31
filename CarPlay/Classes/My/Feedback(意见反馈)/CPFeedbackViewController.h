//
//  CPFeedbackViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"

@interface CPFeedbackViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *buttonAndMsgView;
@property (weak, nonatomic) IBOutlet UIButton *addImgBtn;
- (IBAction)addImg:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *msgLable;
@property (weak, nonatomic) IBOutlet UILabel *buttonAndMsgViewButtomLable;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *contentButtomLable;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
