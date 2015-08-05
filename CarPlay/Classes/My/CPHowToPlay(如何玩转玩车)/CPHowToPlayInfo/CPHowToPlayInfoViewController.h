//
//  CPHowToPlayInfoViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/8/1.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"

@interface CPHowToPlayInfoViewController : BaseViewController
@property (strong, nonatomic) NSString *content;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
