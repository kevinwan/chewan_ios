//
//  ExerciseMatchingSelectView.h
//  CarPlay
//
//  Created by 公平价 on 15/10/21.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJNIndexView.h"
#import "CPExerciseMatchingSelectButton.h"

@interface ExerciseMatchingSelectView : UIViewController<UITableViewDataSource,UITableViewDelegate,MJNIndexViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *selectPlace;
- (IBAction)shuttle:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *matchingBtn;
- (IBAction)selectPlaceClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shuttleBtn;
//1包接送  0不包接送
@property (nonatomic, strong) NSString *whetherShuttle;
- (IBAction)matchingBtnClick:(id)sender;
- (IBAction)exerciseBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *lastStepBtn;
- (IBAction)lastStep:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *locationAddressView;

@property (weak, nonatomic) IBOutlet UIView *addressSelection;
- (IBAction)closeLocatoinAddressView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *reSelectionButton;
- (IBAction)confirm:(id)sender;
- (IBAction)reSelection:(id)sender;
@property (weak, nonatomic) IBOutlet CPExerciseMatchingSelectButton *footBallBtn;

- (IBAction)closeAddressSelectionView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *locationAddressLable;
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (nonatomic, assign) NSInteger parentId;
//排序后
@property (nonatomic, strong) NSMutableArray *areaList;
//排序前
@property (nonatomic, strong) NSMutableArray *areaListBeforeSort;

@property (nonatomic, strong) MJNIndexView *indexView;
@end
