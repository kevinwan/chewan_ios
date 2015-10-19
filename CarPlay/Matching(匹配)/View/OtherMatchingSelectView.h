//
//  MatchingSelectView.h
//  CarPlay
//
//  Created by 公平价 on 15/10/16.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherMatchingSelectView : UIView
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *selectPlace;
- (IBAction)shuttle:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *matchingBtn;
- (IBAction)selectPlaceClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shuttleBtn;
//1包接送  0不包接送
@property (nonatomic, strong) NSString *whetherShuttle;
- (IBAction)matchingBtnClick:(id)sender;
+(void)show:(NSString *)colorStr;
@property (weak, nonatomic) IBOutlet UIView *locationAddressView;

@property (weak, nonatomic) IBOutlet UIView *addressSelection;
- (IBAction)closeLocatoinAddressView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *reSelectionButton;
- (IBAction)confirm:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *reSelection;
- (IBAction)closeAddressSelectionView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *locationAddressLable;
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@end
