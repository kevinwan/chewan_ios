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
    
    [self setRightNavigationBarItemWithTitle:@"我的关注" Image:nil highImage:nil target:self action:@selector(gotoMyInfo)];
    
    // 加载关注信息
    [self setupMyCare];
  
}


// 临时跳转
- (void)gotoMyInfo{
    
}



#pragma mark - 加载网络数据
- (void)setupMyCare{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
//    parameters[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
    
    
    NSString *getUrl = @"http://cwapi.gongpingjia.com:8080/v2/user/5608bc1a0cf2c4f648d9bcd5/subscribe?token=399e45a8-9e72-4734-a1e2-25a0229c549c";
    
    [ZYNetWorkTool getWithUrl:getUrl params:nil success:^(id responseObject) {
        //
        DLog(@"%@",responseObject);
        if (CPSuccess) {
            
        }
        
        
    } failure:^(NSError *error) {
        //
    }];
    
    
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
