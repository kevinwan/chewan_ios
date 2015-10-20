//
//  MatchingSelectView.h
//  CarPlay
//
//  Created by 公平价 on 15/10/20.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchingSelectView : UIViewController
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *selectPlace;
- (IBAction)shuttle:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *matchingBtn;
- (IBAction)selectPlaceClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shuttleBtn;
//1包接送  0不包接送
@property (nonatomic, strong) NSString *whetherShuttle;
- (IBAction)matchingBtnClick:(id)sender;
@end
