//
//  CPMyInfoController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/29.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoController.h"
#import "CPMyInfoFirCell.h"
#import "CPMyInfoSecCell.h"
#import "CPMyInfoThrCell.h"
#import "CPMyInfoHead.h"

@interface CPMyInfoController ()<ZHPickViewDelegate>

@end

@implementation CPMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewDidLoad];  
}

- (void)setupViewDidLoad{
    // 设置导航栏
    self.title = @"个人信息";
    [self setRightNavigationBarItemWithTitle:@"完成" Image:nil highImage:nil  target:self action:@selector(finish)];
    
    // 设置head
    self.tableView.tableHeaderView = [CPMyInfoHead createHead];
}

- (void)finish{
    
}

#pragma mark - Table view data source

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        NSString *str = @"1990年01月01号";
        fmt.dateFormat = @"yyyy年MM月dd号";
        NSDate *defualtDate = [fmt dateFromString:str];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:defualtDate datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
    }
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:index];
        double age=[resultString doubleValue]/31536000;
        NSLog(@"%.0f岁",0-age);
        NSDate *brithDay=[[NSDate alloc]initWithTimeIntervalSinceNow:[resultString doubleValue]];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:brithDay]; // Get necessary date components
        
//        [Tools setValueForKey:[[NSString alloc]initWithFormat:@"%.0f岁",0-age] key:@"age"];
}
@end
