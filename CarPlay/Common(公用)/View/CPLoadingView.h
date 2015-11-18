//
//  CPLoadingView.h
//  CarPlay
//
//  Created by chewan on 10/16/15.
//  Copyright © 2015 chewan. All rights reserved.
// 一个加载中的View(ZYSu)

#import <Foundation/Foundation.h>

@interface CPLoadingView : NSObject
ZYSingleTonH
- (void)showLoadingView;
- (void)dismissLoadingView;
@end
