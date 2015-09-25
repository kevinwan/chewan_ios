//
//  CPMyCareController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyCareController.h"
#import "CPTopButton.h"

@interface CPMyCareController ()

// 顶部三个关注按钮
@property (weak, nonatomic) IBOutlet CPTopButton *careEachBtn;
@property (weak, nonatomic) IBOutlet CPTopButton *myCareBtn;
@property (weak, nonatomic) IBOutlet CPTopButton *careMeBtn;

// 顶部三个关注按钮点击事件
- (IBAction)careClick:(UIButton *)btn;


// 顶部三个关注按钮下三条线
@property (weak, nonatomic) IBOutlet UIView *oneLine;
@property (weak, nonatomic) IBOutlet UIView *twoLine;
@property (weak, nonatomic) IBOutlet UIView *threeLine;

@end

@implementation CPMyCareController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}


- (IBAction)careClick:(UIButton *)btn{
    // 切换按钮颜色
    [self changeColor:btn.tag];
}

// 切换颜色
- (void)changeColor:(NSInteger)btnTag{
    
    [self.careEachBtn setTitleColor:[Tools getColor:@"999999"] forState:UIControlStateNormal];
    [self.myCareBtn setTitleColor:[Tools getColor:@"999999"] forState:UIControlStateNormal];
    [self.careMeBtn setTitleColor:[Tools getColor:@"999999"] forState:UIControlStateNormal];
    
    [self.oneLine setBackgroundColor:[Tools getColor:@"efefef"]];
    [self.twoLine setBackgroundColor:[Tools getColor:@"efefef"]];
    [self.threeLine setBackgroundColor:[Tools getColor:@"efefef"]];
    
    if (btnTag == 10) {
        [self.careEachBtn setTitleColor:[Tools getColor:@"fe5969"] forState:UIControlStateNormal];
        [self.oneLine setBackgroundColor:[Tools getColor:@"fe5969"]];
    }else if(btnTag == 20){
       [self.myCareBtn setTitleColor:[Tools getColor:@"fe5969"] forState:UIControlStateNormal];
    [self.twoLine setBackgroundColor:[Tools getColor:@"fe5969"]];
    }else{
        [self.careMeBtn setTitleColor:[Tools getColor:@"fe5969"] forState:UIControlStateNormal];
        [self.threeLine setBackgroundColor:[Tools getColor:@"fe5969"]];
    }
    
}




@end
