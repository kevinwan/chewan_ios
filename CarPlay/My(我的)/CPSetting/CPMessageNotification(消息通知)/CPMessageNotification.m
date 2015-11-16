//
//  CPMessageNotification.m
//  CarPlay
//
//  Created by 公平价 on 15/11/16.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMessageNotification.h"
#import "CPMySwitch.h"

@interface CPMessageNotification ()

@end

@implementation CPMessageNotification

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"消息通知"];
    [_soundSwitch setOnImage:[UIImage imageNamed:@"nodistrube.png"]];
    [_soundSwitch setOffImage:[UIImage imageNamed:@"nodistrube_gray.png"]];
    [_soundSwitch addTarget:self action:@selector(soundSwitch:) forControlEvents:UIControlEventTouchUpInside];
//    _soundSwitch.on = self.isBlocked;
    [_vibrationSwitch setOnImage:[UIImage imageNamed:@"nodistrube.png"]];
    [_vibrationSwitch setOffImage:[UIImage imageNamed:@"nodistrube_gray.png"]];
    [_vibrationSwitch addTarget:self action:@selector(vibrationSwitch:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    if ([ZYUserDefaults boolForKey:kRemindMessageSound]) {
        [_soundSwitch setOn:YES];
    }else{
        [_soundSwitch setOn:NO];
    }
    
    if ([ZYUserDefaults boolForKey:kRemindVibration]) {
        [_vibrationSwitch setOn:YES];
    }else
        [_vibrationSwitch setOn:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)soundSwitch:(CPMySwitch *) soundSwitch{
    if ([soundSwitch on]) {
        [ZYUserDefaults setBool:YES forKey:kRemindMessageSound];
    }else
        [ZYUserDefaults setBool:NO forKey:kRemindMessageSound];
}

-(void)vibrationSwitch:(CPMySwitch *) vibrationSwitch{
    if ([vibrationSwitch on]) {
        [ZYUserDefaults setBool:YES forKey:kRemindVibration];
    }else
        [ZYUserDefaults setBool:NO forKey:kRemindVibration];
}
@end
