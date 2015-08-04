//
//  CPActivityApplyModel.m
//  CarPlay
//
//  Created by chewan on 15/7/21.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActivityApplyModel.h"

@implementation CPActivityApplyModel
MJCodingImplementation

- (void)setContent:(NSString *)content
{
    _content = [content copy];
    
    if (_type) {
        [self setAttrbuteText];
    }
}

- (void)setType:(NSString *)type
{
    _type = [type copy];
    
    if (_content) {
        [self setAttrbuteText];
    }
}

- (void)setAttrbuteText
{
    NSAttributedString *head;
    NSAttributedString *middle = [[NSAttributedString alloc] initWithString:_content attributes:@{NSForegroundColorAttributeName :[Tools getColor:@"48d1d5"]}];
    NSAttributedString *footer;
    if ([_type isEqualToString:@"车主认证"]) { // 车主认证
        head = [[NSAttributedString alloc] initWithString:@"你提交的"];
     
    }else if ([_type isEqualToString:@"活动邀请"]){ // 活动邀请
        head = [[NSAttributedString alloc] initWithString:@"邀您加入"];
        footer = [[NSAttributedString alloc] initWithString:@"活动"];
    }else if ([_type isEqualToString:@"活动申请结果"]){ //活动申请结果
        head = [[NSAttributedString alloc] initWithString:@"活动申请: "];
        footer = [[NSAttributedString alloc] initWithString:@"同意您的申请"];
    }else if ([_type isEqualToString:@"活动申请处理"]){
        head = [[NSAttributedString alloc] initWithString:@"想加入"];
         footer = [[NSAttributedString alloc] initWithString:@"活动"];
    }else{
        _text = [[NSAttributedString alloc] initWithString:@"带我飞"];;
        return;
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    [text appendAttributedString:head];
    [text appendAttributedString:middle];
    if (footer) {
        [text appendAttributedString:footer];
    }
    _text = text;
}

/**
 *  生成seat的属性字符串
 *
 *  @param seat seat description
 */
- (void)setSeat:(NSNumber *)seat
{
    _seat = seat;

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"提供"];
    
    NSString *seatString = [NSString stringWithFormat:@"%zd",seat.intValue];
    NSMutableAttributedString *seatAttr = [[NSMutableAttributedString alloc] initWithString:seatString attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"fc6e51"]}];
    [str appendAttributedString:seatAttr];
    NSAttributedString *zuo = [[NSAttributedString alloc] initWithString:@"座位"];
    [str appendAttributedString:zuo];
    
    _seatText = str;
}


@end
