//
//  CPChatGroupDetailController.m
//  CarPlay
//
//  Created by chewan on 15/8/20.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPChatGroupDetailController.h"
#import "CPIconButton.h"
#import "CPMoreButton.h"
#import "CPOrganizerButton.h"

#define MaxMemberCount 9  // 最大显示的参与成员数

@interface CPChatGroupDetailController()
// 参与成员的photoView
@property (weak, nonatomic) IBOutlet UIView *memberPhotoView;

// 活动介绍的label
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

// 活动介绍cell的行高
@property (nonatomic, assign) CGFloat introduceCellHeight;

// 组织者的button
@property (weak, nonatomic) IBOutlet CPOrganizerButton *organizerButton;

@end

@implementation CPChatGroupDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.introduceLabel.height = 50;
    self.introduceLabel.preferredMaxLayoutWidth = kScreenWidth - 20;
    CGFloat btnWH = 25;
    CGFloat maxX = 0;
    for (int i = 0 ; i < 7; i ++) {
        
        CPIconButton *btn = [CPIconButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"placeholderImage"] forState:UIControlStateNormal];
        btn.x = i * (btnWH + 5);
        btn.y = 0;
        btn.width = btnWH;
        btn.height = btnWH;
        [self.memberPhotoView addSubview:btn];
        maxX = (i + 1) * (btnWH + 5);
    }
    
    CPMoreButton *moreBtn = [CPMoreButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:[NSString stringWithFormat:@"%zd",self.memberPhotoView.subviews.count] forState:UIControlStateNormal];
    moreBtn.x = maxX;
    moreBtn.y = 0;
    moreBtn.width = btnWH;
    moreBtn.height = btnWH;
    [self.memberPhotoView addSubview:moreBtn];
    
    self.introduceLabel.text = @"sajisdfljalsdjkldafsjlaskdfjlkdasfjkaldsjdlafksjdslfjdasfkljdafkljafdskljaflhfdlhdfsladflaefhdlfdlfdhalsfh";
    CGFloat height = [self.introduceLabel.text sizeWithFont:self.introduceLabel.font maxW:kScreenWidth - 20].height;
    self.introduceLabel.height = height;
    
    self.introduceCellHeight = height + 62;
    
    self.organizerButton.icon = @"ceo头像";
    self.organizerButton.name = @"死磕到底jsfdjdhflkjl";
    
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 87;
    }else if (indexPath.row == 1){
        return self.introduceCellHeight;
    }else{
        return 50;
    }
}

@end
