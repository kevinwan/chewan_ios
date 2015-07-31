//
//  CPActivityNameController.m
//  CarPlay
//
//  Created by chewan on 15/7/18.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActivityNameController.h"
#import "NSString+Extension.h"

@interface CPActivityNameController ()
@property (nonatomic, strong) UITextField *textF;
@end

@implementation CPActivityNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动名称";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName :[UIColor whiteColor]} forState:UIControlStateNormal];
    
    UITextField *textF = [[UITextField alloc] init];
    textF.textColor = [Tools getColor:@"656c78"];
    textF.font = [UIFont systemFontOfSize:14];
    textF.frame = CGRectMake(10, 20 + 64, self.view.width - 20, 30);
    if (self.forValue) {
        textF.text = self.forValue;
    }
    [self.view addSubview:textF];
    self.textF = textF;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [Tools getColor:@"aab2bd"];
    line.x = 0;
    line.y = textF.bottom + 10;
    line.width = self.view.width;
    line.height = 0.5;
    [self.view addSubview:line];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = [Tools getColor:@"aab2bd"];
    lable.numberOfLines = 0;
    lable.attributedText = [[NSAttributedString alloc] initWithString:@"去活动名称时最好带上地点和基本要求\n例如昆明湖一日游"];
    lable.x = 10;
    lable.width = self.view.width - 20;
    lable.height = [lable.text sizeWithFont:lable.font maxW:lable.width].height;
    lable.y = line.bottom + 10;
    [self.view addSubview:lable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textF becomeFirstResponder];
}

- (void)confirm
{
    if (self.textF.text.length == 0) {
        [self showInfo:@"你不能输入空的活动介绍"];
        return;
    }
    
    if (self.completion) {
        self.completion(self.textF.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textF resignFirstResponder];
}
@end
