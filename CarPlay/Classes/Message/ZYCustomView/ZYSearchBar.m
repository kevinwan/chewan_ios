//
//  ZYSearchBar.m
//
//
//  Created by apple on 14-10-8.
//  Copyright (c) 2014年 suzhaoyun. All rights reserved.
//

#import "ZYSearchBar.h"

@interface ZYSearchBar ()<UITextFieldDelegate>

@end

@implementation ZYSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [Tools getColor:@"434a54"];
        self.placeholder = @"请输入搜索条件";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"查找"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIButton *clearBtn = [[UIButton alloc] init];
        [clearBtn setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
        clearBtn.width = 30;
        clearBtn.height = 30;
        self.rightView = clearBtn;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
        
        self.delegate = self;
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

- (void)clearText
{
    self.text = nil;
}

@end
